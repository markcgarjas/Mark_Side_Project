class Users::ShareController < ApplicationController
  def index
    @user = current_user
    @winners = Winner.where(state: :published)
  end
end
