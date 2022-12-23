# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  layout 'admins/admin_login_session'
  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    @user = User.find_by_email(params[:admins_user][:email])
    if @user&.client? && @user&.valid_password?(params[:admins_user][:password])
      flash[:alert] = "Invalid Email or password."
      redirect_to new_user_session_path
    else
      super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
