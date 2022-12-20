class Users::HomesController < ApplicationController
  before_action :authenticate_users_user!, except: :index

  def index
    @winners = Winner.includes(:user).published.limit(5)
    @items = Item.active.starting.limit(5)
  end
end
