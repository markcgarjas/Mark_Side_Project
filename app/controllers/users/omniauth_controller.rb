# frozen_string_literal: true

class Users::OmniauthController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      redirect_to new_user_registration_url
    end
    # render json: request.env['omniauth.auth']
  end

  def google_oauth2
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      redirect_to new_user_registration_url
    end
    # render json: request.env['omniauth.auth']
  end

  def failure
    flash[:alert] = @user.errors.full_messages.join(", ")
    redirect_to new_user_registration_url
  end
end