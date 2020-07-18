class User < ApplicationRecord
 # 同じ名前を使えなくする
  attachment :image
  validates :name, uniqueness: true
  validates :occupation, presence: { message: 'を選択してください。' }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable,
         # Omniauthを使用するためのオプション
         :omniauthable, omniauth_providers: %i[google_oauth2]
         has_many :sns_credentials, dependent: :destroy
         has_many :posts, dependent: :destroy

 # current_passwordなしでプロフィール編集する
  attr_accessor :current_password

 # SNS認証用
 def self.without_sns_data(auth)
    user = User.where(email: auth.info.email).first

      if user.present?
        sns = SnsCredential.create(
          uid: auth.uid,
          provider: auth.provider,
          user_id: user.id
        )
      else
        user = User.new(
          name: auth.info.name,
          email: auth.info.email,
        )
        sns = SnsCredential.new(
          uid: auth.uid,
          provider: auth.provider
        )
      end
      return { user: user ,sns: sns}
    end

   def self.with_sns_data(auth, snscredential)
    user = User.where(id: snscredential.user_id).first
    unless user.present?
      user = User.new(
        name: auth.info.name,
        email: auth.info.email,
      )
    end
    return {user: user}
   end

   def self.find_oauth(auth)
    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    if snscredential.present?
      user = with_sns_data(auth, snscredential)[:user]
      sns = snscredential
    else
      user = without_sns_data(auth)[:user]
      sns = without_sns_data(auth)[:sns]
    end
    return { user: user ,sns: sns}
  end

 #グラフの横軸用
  def posts_period(period)
    current = Time.current.beginning_of_day
    case period
    when "week"
      start_date = current.ago(6.days)
    when "month"
      start_date = current.ago(1.month - 1.day)
    when "year"
      start_date = current.ago(1.year - 1.day)
    else
      start_date = current.ago(6.days)
    end
    end_date = Time.current
    dates = {}
    (start_date.to_datetime...end_date.to_datetime).each do |date|
      posts = self.posts.where(created_at: date.beginning_of_day...date.end_of_day)
      sum_times = posts.sum("hour + minutes/60").round(1)
      dates.store(date.to_date.to_s, sum_times)
    end
    return dates
  end
end
