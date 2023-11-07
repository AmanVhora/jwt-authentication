class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[create]
  before_action :find_user, only: %i[show update destroy authorize_user]
  before_action :authorize_user, only: %i[show update destroy]

  def index
    @users = User.all
    render json: @users, status: 200 
  end

  def show
    render json: @user, status: 200 
  end

  def create
    @user = User.create(user_params)
    if @user.save
      render json: @user, status: 201
    else
      render json: { errors: @user.errors.full_messages }, status: 503
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 503
    end
  end

  def destroy
    @user.destroy
    render json: @user, status: 200
  end

  private
  def user_params
    params.require(:user).permit(:name, :username, :email, :password)
  end

  def find_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Record not found' }, status: 404
    end
  end

  def authorize_user
    render json: { error: 'You are not authorize for perform this action.' }, status: :unauthorized unless @user == @current_user
  end
end
