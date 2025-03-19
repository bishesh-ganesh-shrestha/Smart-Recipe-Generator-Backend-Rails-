# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json
  before_action :configure_sign_in_params, only: [ :create ]
  before_action :authenticate_user!, only: [:show]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: {
      status: 200,
      message: "User fetched successfully.",
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: params[:session][:user][:email])

    if user.blank?
      return render json: {
          status: { message: "This email is not registered." }
        }, status: :unprocessable_entity
    elsif user.present? && !user.valid_password?(params[:session][:user][:password])
      return render json: {
          status: { message: "Incorrect Password." }
        }, status: :unprocessable_entity
    end

    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :phone, :email, :password ])
  end

  private

  def respond_with(resource, _opt = {})
    @token = request.env["warden-jwt_auth.token"]
    return head :unauthorized unless @token

    headers["Authorization"] = @token

    render json: {
      status: 200,
      message: "Logged in successfully.",
      token: @token,
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def respond_to_on_destroy
    return head :unauthorized unless request.headers["Authorization"].present?

    begin
      jwt_payload = JWT.decode(
        request.headers["Authorization"].split.last,
        Rails.application.credentials.devise_jwt_secret_key!
      ).first

      current_user = User.find_by(id: jwt_payload["sub"])

      if current_user
        if current_user.jti != jwt_payload["jti"]
          return render json: { status: 401, message: "User already logged out." }, status: :unauthorized
        end

        current_user.update!(jti: SecureRandom.uuid)
        render json: {
          status: 200,
          message: "Logged out successfully."
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Invalid session"
        }, status: :unauthorized
      end
    rescue JWT::DecodeError, JWT::VerificationError
      render json: {
        status: 401,
        message: "Invalid token"
      }, status: :unauthorized
    end
  end
end
