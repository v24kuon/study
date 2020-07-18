class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,except: [:index]


  def index
    @posts = Post.all
  end


  def show
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
      redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:tag, :body, :hour, :minutes, :image, :post_video)
    end
end
