# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  #
  # GET /resource/sign_up
  def new
    super
    unless cookies[:promoter]
      cookies[:promoter] = params[:promoter]
    end
  end

  # POST /resource
  def create
    cookies[:promoter]
    params[:user][:parent_id] = User.find_by(email: cookies[:promoter])&.id
    super
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    parameter = params[:user]
    if parameter[:current_password].present? || parameter[:password].present? || parameter[:password_confirmation].present?
      update_user_with_password
    else
      update_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone, :image, :username)
  end

  def user_with_password_params
    params.require(:user).permit(:phone, :image, :username, :current_password, :password_confirmation, :password)
  end

  def update_user_with_password
    if @user.update_with_password(user_with_password_params)
      flash[:notice] = t("update_successfully")
      redirect_to users_profile_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      redirect_to edit_user_registration_path
    end
  end

  def update_user
    if @user.update(user_params)
      flash[:notice] = t("update_successfully")
      redirect_to users_profile_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      redirect_to edit_user_registration_path
    end
  end

  # def create_user
  #   if @user.create(user_login_params)
  #     flash[:notice] = "User created"
  #     redirect_to me_path
  #   else
  #     render :edit
  #   end
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :parent_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
