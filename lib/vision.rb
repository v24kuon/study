require 'base64'
require 'json'
require 'net/https'
module Vision
  class << self
    def get_ocr_data(base64_image)
      # APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_VISION_API_KEY']}"
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'DOCUMENT_TEXT_DETECTION'
            }
          ]
        }]
      }.to_json
      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      # APIレスポンス出力
      if response.code == "200" && !JSON(response.body)['responses'].empty?
        return JSON.parse(response.body)['responses'][0]['textAnnotations'].pluck('description')[0]
      else
        raise Exception, '変換できませんでした.'
      end
    end
  end
end