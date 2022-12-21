class Users::ShareController < ApplicationController
  def index
    @user = current_user
    @winners = Winner.where(state: :published)
    @news_tickers = NewsTicker.active.limit(5)
    @banners = Banner.where('online_at <= ? AND offline_at > ?', Time.current, Time.current)
                     .active.limit(5)
  end
end
