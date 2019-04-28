class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login create]

  def login
    authenticate params[:email], params[:password]
  end

  def create
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully'}
      render json: response, status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  def show
    render json: current_user.to_json(except: :password_digest)
  end

  private

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
