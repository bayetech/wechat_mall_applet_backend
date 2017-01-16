class ProductQrCodesController < BaseController
  def image
    file_name = check_page_path
    return render status: 403, json: { errcode: 1, msg: '这个小程序地址不在rapi白名单中' } if file_name.nil?

    file = Wechat.api.wxa_create_qrcode(params[:path]).open
    file_path = Rails.root.join('public', 'page_qr_codes', file_name)
    IO.binwrite(file_path, file.read)

    url = request.base_url + '/public/page_qr_codes/' + file_name
    return render json: { url: url }
  end

  private

  def check_page_path
    case params[:path]
    when %r(pages/show_product/show_product\?id=(\d+)&share=1\z)
      "show_product_#{$1}_share.jpg"
    when %r(pages/index/index\z)
      "index.jpg"
    else
      nil
    end
  end
end
