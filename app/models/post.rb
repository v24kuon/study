class Post < ApplicationRecord
  belongs_to :user
  attachment :image
  validates :tag, :body, :hour, :minutes, presence: true
end
