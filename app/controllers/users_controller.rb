class UsersController < ApplicationController
  before_action :baria_user, only: [:update, :edit]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!

  def show
 # ユーザーの全投稿
    if :created_at == :updated_at
      @posts = @user.posts.page(params[:page]).order(created_at: :desc).per(8)
    else @posts = @user.posts.page(params[:page]).order(updated_at: :desc).per(8)
    end
    @total_hour = @user.posts.sum("hour + minutes/60")
 #グラフの表示用
    @period = params[:period]
    @chart = @user.posts_period(@period)
 #タグ検索
    if params[:tag_name]
      @tasks = @user.posts.tagged_with("#{params[:tag_name]}")
    end
  end

  def edit
  end

  def update
      if @user.update(user_params)
        redirect_to @user
      else
        render 'edit'
      end
  end

  def favorite
    @user = User.find_by(id: params[:id])
    @favorite_count = Favorite.where(user_id: @user.id).count
    if :created_at == :updated_at
      @favorites = Favorite.where(user_id: @user.id).page(params[:page]).order(created_at: :desc)
    else @favorites = Favorite.where(user_id: @user.id).page(params[:page]).order(updated_at: :desc)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
  	params.require(:user).permit( :image, :name, :introduction, :occupation, :tag_list)
  end

  #url直接防止　メソッドを自己定義してbefore_actionで発動。
   def baria_user
  	unless params[:id].to_i == current_user.id
  		redirect_to user_path(current_user)
  	end
   end

end