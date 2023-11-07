class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user
  
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      time = Time.now + 24.hours.to_i
      token = jwt_encode(user_id: @user.id, exp: time.to_i)
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: @user.username }, status: :ok
    else
      render json: { error: 'Authentication failed! Incorrect email or password.' }, status: :unauthorized
    end
  end
end
