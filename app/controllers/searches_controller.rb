class SearchesController < ApplicationController
  def search
    @range = params[:range]
    word = params[:word]

    if @range == '1'
      @users = User.where("name LIKE?","%#{word}%").order(created_at: :desc).page(params[:page]).per(25)
    elsif @range == '2'
      if :created_at == :updated_at
        @posts = Post.tagged_with("#{params[:word]}", :any => true,:wild => true).order(created_at: :desc).page(params[:page]).per(25)
      else
        @posts = Post.tagged_with("#{params[:word]}", :any => true,:wild => true).order(updated_at: :desc).page(params[:page]).per(25)
      end
    else
      if :created_at == :updated_at
        @posts = Post.where("body LIKE?","%#{word}%").order(created_at: :desc).page(params[:page]).per(25)
      else
        @posts = Post.where("body LIKE?","%#{word}%").order(updated_at: :desc).page(params[:page]).per(25)
      end
    end
  end
end

