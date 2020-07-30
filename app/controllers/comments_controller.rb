class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(comment_params)
    comment.user_id = current_user.id
    if comment.save
      @comments = post.comments
      @comments_count = @comments.count
      @comments_count_class = (@comments_count == 0)? "comments-none" : "comments-exist"
      render :index
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    post = Post.find(params[:post_id])
    if comment.destroy
      @comments = post.comments
      @comments_count = @comments.count
      @comments_count_class = (@comments_count == 0)? "comments-none" : "comments-exist"
      render :index
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content, :post_id, :user_id)
    end

end
