class Users::ShopController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    @offers = Offer.active
    @order = Order.new
    @news_tickers = NewsTicker.active.limit(5)
    @banners = Banner.where('online_at <= ? AND offline_at > ?', Time.current, Time.current)
                     .active.limit(5)
  end

  def create
    @order = Order.new(order_params)
    @offer = Offer.active.find(params[:order][:offer_id])
    @order.user = current_user
    @order.coin = @offer.coin
    @order.genre = :deposit
    @order.amount = @offer.amount
    @order.state = :submitted
    if @order.save
      flash[:notice] = "Order Successfully"
      redirect_to users_shop_index_path
    else
      flash[:alert] = @order.errors.full_messages.join(", ")
      redirect_to users_shop_index_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:offer_id)
  end
end
