class ConversionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ocr
  	#postのbodyのbase64の画像をvisionapiに渡す
  	result = Vision.get_ocr_data(params[:base64_image])
     #結果をjsonで返却する
  	render :json => {
  		result: result
  	}
  end
end
