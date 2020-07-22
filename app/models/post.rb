class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

 # 画像投稿機能
  attachment :image
  # タグ付け機能
  acts_as_taggable
 # 空白を禁止する
  validates :body, :hour, :minutes, presence: true

  def self.search(search, word)
    if search == "forward_match"
      @post = Post.where("body LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("body LIKE?","%#{word}")
    elsif search == "perfect_match"
      @post = Post.where("#{word}")
    elsif search == "partial_match"
      @post = Post.where("body LIKE?","%#{word}%")
    else @post = Post.all
    end
  end



  def self.sum_times
  	posts.sum("hour + minutes/60").round(1)
  end
end
