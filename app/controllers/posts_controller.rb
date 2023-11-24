class PostsController < ApplicationController
  skip_before_action :authenticate_user, only: %i[index]
  before_action :find_post, only: %i[show update destroy authorize_user]
  before_action :authorize_user, only: %i[show update destroy]

  def index
    posts = Post.all
    render json: posts
  end

  def show
    render json: @post
  end

  def create
    post = @current_user.posts.new(post_params)
    if post.save
      render json: post, status: :created, location: post
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    render json: { message: 'Post successfully deleted' }
  end

  private
    def find_post
      begin
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: 'Record not found' }, status: 404
      end
    end

    def post_params
      params.require(:post).permit(:caption, images: [])
    end

    def authorize_user
      render json: { error: 'You are not authorize for perform this action.' }, status: :unauthorized unless @post.user == @current_user
    end
end
