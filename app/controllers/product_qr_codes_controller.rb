class ProductQrCodesController < ApplicationController
  def show
    file = Wechat.api.wxa_create_qrcode(params[:path]).open
    IO.binwrite('/root/out.jpg', file.read)

    return render json: {}
  end
end
