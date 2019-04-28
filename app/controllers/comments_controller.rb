class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(post_params.merge(commentable: references))
    if @comment.save
      render json: @comment.to_json, status: :created
    else
      render json: @comment.errors, status: :bad
    end
  end

  private

  def references
    Post.find_by(id: params[:post_id]) || Comment.find_by(id: params[:comment_id])
  end

  def post_params
    params.require(:comment).permit(:body)
  end
end
