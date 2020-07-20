class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,except: [:index]


  def index
 # 全投稿を表示
    @posts = Post.page(params[:page]).reverse_order
 # タグ検索
    if params[:tag_user]
       @search = Post.ransack(params[:q])
       @users = User.tagged_with("#{params[:tag_user]}")
       @posts = Post.where(user_id: @users)
    elsif params[:tag_name]
       @search = Post.ransack(params[:q])
       @posts = Post.tagged_with("#{params[:tag_name]}")
 # 検索ボックス
    elsif @search = Post.ransack(params[:q])
       @posts = @search.result
    end

    # @ranking_posts = Post.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
    #   .group('user_id')
    #   .order('sum(hour + minutes / 60) DESC')

    # SELECT "users".* FROM "users"
    # LEFT OUTER JOIN "posts" ON "posts"."user_id" = "users"."id"
    # WHERE "posts"."created_at"
    #   BETWEEN ? AND ?
    # GROUP BY posts.user_id
    # ORDER BY sum(posts.hour + posts.minutes / 60) DESC
    # [["created_at", "2020-06-30 15:00:00"], ["created_at", "2020-07-31 14:59:59.999999"]]

    @users = User.all
    @ranking_users = User.left_joins(:posts)
      .where(posts: { created_at: Time.current.beginning_of_month..Time.current.end_of_month })
      .group('posts.user_id')
      .order('sum(posts.hour + posts.minutes / 60) DESC')
    # @ranks = Post.where(:created_at=> Time.current.beginning_of_month..Time.current.end_of_month).sum("hour + minutes/60")
    # user.posts.where(
    #   :created_at=> Time.current.beginning_of_month..Time.current.end_of_month).pluck(:hour).sum
    #   + user.posts.where(:created_at=> Time.current.beginning_of_month..Time.current.end_of_month
    # ).pluck(:minutes).sum / 60
  end


  def show
    @comment = Comment.new
    @comments = @post.comments
  end


  def new
    @post = Post.new
  end


  def edit
  end


  def create
    @post = Post.new(post_params) #Postモデルのテーブルを使用しているのでpostコントローラで保存する。
    @post.user_id = current_user.id
    if@post.save #入力されたデータをdbに保存する。
      redirect_to @post, notice: "投稿しました"#保存された場合の移動先を指定。
    else
      render 'new'
    end
  end


  def update
      if @post.update(post_params)
        redirect_to @post, notice: 'Post was successfully updated.'
      else
        render 'edit'
      end
  end


  def destroy
    @post.destroy
      redirect_to user_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:body, :hour, :minutes, :image, :post_video, :tag_list)
    end
end
