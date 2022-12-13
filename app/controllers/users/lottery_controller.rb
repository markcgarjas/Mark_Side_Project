class Users::LotteryController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    @items = Item.where(status: :active, state: :starting)
    @items = @items.includes(:categories).where(categories: { name: params[:category] }) if params[:category]
    @categories = Category.all
  end

  def show
    @bets = Bet.includes(:user, :item).all
    @item = Item.where(state: :starting).find(params[:id])
    @bet = Bet.new
    @owner_users = @bets.where(user: current_user, batch_count: @item.batch_count, item: @item)
  end

  def create
    @betting = params[:bet][:coins].to_i
    params[:bet][:coins] = 1
    @betting.times {
      @bet = Bet.new(item_params)
      @item = Item.find(params[:bet][:item_id])
      @bet.item = @item
      @bet.user = current_user
      @bet.batch_count = @item.batch_count
      @bet.save!
    }
    flash[:notice] = "Created Successfully"
    redirect_to users_lottery_index_path
  rescue ActiveRecord::RecordInvalid => invalid
    flash[:notice] = invalid
    redirect_to users_lottery_index_path
  end

  private

  def item_params
    params.require(:bet).permit(:coins, :item_id)
  end
end
