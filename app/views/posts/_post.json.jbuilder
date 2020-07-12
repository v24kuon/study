json.extract! post, :id, :tag, :body, :study_time, :post_image, :post_video, :created_at, :updated_at
json.url post_url(post, format: :json)
