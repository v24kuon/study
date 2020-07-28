class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,except: [:index, :show, :about]


  def index

    if :created_at == :updated_at
      @posts = Post.order(created_at: :desc).page(params[:page]).per(8)
    else
      @posts = Post.order(updated_at: :desc).page(params[:page]).per(8)
    end
 # 年代別の表示
    @occupations = '小学生','中学生','高校生','専門学校・大学生','その他・社会人'
    if params[:occupation_name].present?
      @posts = @posts.joins(:user).where(users: {occupation: params[:occupation_name]}).page(params[:page])
 # タグ検索
    elsif params[:tag_user].present?
      @search = @posts.ransack(params[:q])
      @users = User.tagged_with("#{params[:tag_user]}")
      @posts = @posts.where(user_id: @users).page(params[:page])
    elsif params[:tag_name].present?
      @search = @posts.ransack(params[:q])
      @posts = @posts.tagged_with("#{params[:tag_name]}").page(params[:page])
    elsif params[:keyword] == 'likes'
      @posts = Post.favorite_sort.page(params[:page]).per(8)
    elsif params[:keyword] == 'comments'
      @posts = Post.comment_sort.page(params[:page]).per(8)

      # binding.pry

  #     sort_posts_ids = Post.post_sort(params[:keyword], @posts_ids)
  #     @posts_ids = sort_posts_ids.concat(@posts_ids)
  #     @posts_ids = @posts_ids.uniq
  #     @posts = Post.find(@posts_ids)
  #     #ActiveRecord::Relationに変換できたらソート可能になる
  #     @posts = Post.where(id: @post_ids).order("FIELD(id, #{@post_ids.join(',')})")
  #     @posts = @posts.page(params[:page]).per(5)
    end

    @users = User.all
    @ranking_users = User.left_joins(:posts)
      .where(posts: { created_at: Time.current.beginning_of_month..Time.current.end_of_month })
      .group('posts.user_id')
      .order(Arel.sql('sum(posts.hour + posts.minutes / 60) DESC'))
      .limit(20)
  end


  def show
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :desc)
  end


  def new
    @post = Post.new
  end


  def edit
  end


  def create
    @post = Post.new(post_params)
 # YouTube読み込み用
    url = params[:post][:post_video]
    @post.post_video = url.last(11)
    @post.user_id = current_user.id
    if @post.save
      redirect_to @post, notice: "投稿しました"
    else
      render 'new'
    end
  end


  def update
 # YouTube読み込み用
    url = params[:post][:post_video]
    @post.post_video = url.last(11)
    @post.user_id = current_user.id
    # binding.pry
    if @post.update(
      body: post_params[:body],
      hour: post_params[:hour],
      minutes: post_params[:minutes],
      image: post_params[:image],
      post_video: post_params[:post_video],
      tag_list: post_params[:tag_list])
      redirect_to user_path(@post.user.id), notice: "更新しました"
    else
      render 'edit'
    end
  end


  def destroy
    @post.destroy
    redirect_to user_path(@post.user.id), notice: "削除しました"
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:body, :hour, :minutes, :image, :post_video, :tag_list)
    end
end
