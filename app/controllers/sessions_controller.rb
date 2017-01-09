require "#{Rails.root}/lib/wxbiz_data_crypt"

class SessionsController < BaseController
  def login
    @mobile      = params[:mobile]
    @token       = request.headers['Authorization']
    @customer    = nil

    if token_valid?
      token_login
      return render status: 403, json: {code: 7, msg: 'token登录出错'} if @customer.nil?
    else
      return render status: 403, json: {code: 4, msg: '需要填写手机号码'} if @mobile.blank?

      case login_type
      when :password
        password_login
        return render status: 403, json: {code: 6, msg: '密码不正确或该账号没有绑定'} if @customer.nil?
      when :mobile_code
        mobilecode_login
        return render status: 403, json: {code: 5, msg: '手机验证码不正确！'} if @customer.nil?
      end
      update_wechat_user_token
    end
    render json: { token: @token, customer: @customer.slice(:name, :mobile, :baye_rank, :id, :account_type) }
  end

  def logout
    # TODO code not used
    # 但 code 每次 token 登录也会变
    param_code = params[:code]
    if current_wechat_user
      current_wechat_user.expire!
      return render status: 200
    else
      return render status: 500
    end
  end

  private

  def login_type
    return :password if params[:password].present?
    return :mobile_code if params[:mobile_code].present?
  end

  def password_login
    c = Customer.find_by mobile: @mobile
    @customer = c if c&.valid_password?(params[:password])
  end

  def mobilecode_login
    return nil if !Verification.validate?(@mobile, params[:mobile_code])
    @customer = Customer.find_by(mobile: @mobile)
    @customer = Customer.new.register!({mobile: @mobile, name: params[:name]}) unless @customer
  end

  def token_login
    return nil unless current_wechat_user
    current_wechat_user.update!(wx_code: params[:code])

    @customer = Customer.find(current_wechat_user.customer_id)
  end

  def update_wechat_user_token
    @token = 'wx_' + SecureRandom.hex(20)
    body = wx_get_session_key(params[:code]) unless Rails.env.development?

    wechat_user = WechatUser.where(open_id: body['openid']).where(app_id: ENV['weapplet_app_id']).first || WechatUser.new
    wechat_user.update_token(body, @customer, @token, params[:code])
    wechat_user.update_info(decrypt(body['session_key']))
  end

  def token_valid?
    return false if @token.blank?
    current_wechat_user
  end

  def wx_get_session_key(code)
    uri = URI('https://api.weixin.qq.com/sns/jscode2session')
    params = { appid: ENV['weapplet_app_id'], secret: ENV['weapplet_secret'], js_code: code, grant_type: 'authorization_code' }
    uri.query = URI.encode_www_form(params)
    JSON.load(Net::HTTP.get_response(uri).body)
  end

  def decrypt(session_key)
    app_id         = ENV['weapplet_app_id']
    encrypted_data = params[:encrypted][:encryptedData]
    iv             = params[:encrypted][:iv]

    pc = WXBizDataCrypt.new(app_id, session_key)
    pc.decrypt(encrypted_data, iv)
  end
end
