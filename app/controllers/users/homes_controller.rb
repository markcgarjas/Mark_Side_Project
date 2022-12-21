class Users::HomesController < ApplicationController
  before_action :authenticate_users_user!, except: :index

  def index
    @winners = Winner.includes(:user).published.limit(5)
    @items = Item.active.starting.limit(5)
    @news_tickers = NewsTicker.active.limit(5)
    @banners = Banner.where('online_at <= ? AND offline_at > ?', Time.current, Time.current)
                     .active.limit(5)
  end
end
