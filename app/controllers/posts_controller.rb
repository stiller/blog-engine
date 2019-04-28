class PostsController < ApplicationController
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      render json: @post.to_json, status: :created
    else
      render json: @post.errors, status: :bad
    end
  end

  def show
    @post = current_user.posts.find(params[:id])

    render json: @post
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
