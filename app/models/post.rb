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
 # 時間の入力制限
  validates :hour, length: { in: 0..23 }
 # 分の入力制限
  validates :minutes, length: { in: 0..59 }
 # 時間か分に値が入っているか
  validate :validHour
  validate :validMinute
 # URLのみ許可
  validate :valid_url_update, on: :update
  validate :valid_url, on: :create

 # ソート機能
  def self.favorite_sort
    Post.left_joins(:favorites).select('posts.*, count(favorites.id) as favorites_count').group(:id).order(favorites_count: :desc).order(created_at: :desc)
  end

  def self.comment_sort
    Post.left_joins(:comments).select('posts.*, count(comments.id) as comments_count').group(:id).order(comments_count: :desc).order(created_at: :desc)
  end

 # 合計時間
  def self.sum_times
  	posts.sum("hour + minutes/60").round(1)
  end
 # 時間と分が0を防ぐ
  def validHour
    errors.add(:hour,"時間か分に1以上入力して下さい") if hour == 0 && minutes == 0
  end
  def validMinute
    errors.add(:minutes,"時間か分に1以上入力して下さい") if hour == 0 && minutes == 0
  end
 # URLのみ許可
  def valid_url
    errors.add(:post_video,"正しいURLを入力して下さい")if !self.post_video.empty? && URI.regexp.match(@url).nil?
  end

  def initialize(params)
    super
    @url = self.post_video
  end

  def valid_url_update
    if post_video.size == 11 || post_video.empty?
      return
    elsif post_video.present? && URI.regexp.match(self.post_video).present?
      return self.post_video = post_video.last(11)
    end

    errors.add(:post_video,"正しいURLを入力して下さい")
  end
end
