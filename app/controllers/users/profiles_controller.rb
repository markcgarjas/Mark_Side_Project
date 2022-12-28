class Users::ProfilesController < ApplicationController
  def show
    @user = current_user
    @orders = Order.where(user: @user) if params[:order] == 'orders'
    @winners = Winner.where(user: @user) if params[:winner] == 'winners'
    @lotteries = Bet.where(user: @user) if params[:lottery] == 'lotteries'
    @invitations = User.where(parent: @user) if params[:invitation] == 'invitations'
  end

  def cancel_event
    @order = current_user.orders.find(params[:id])
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = t("cancel_successfully")
      redirect_to users_profile_path(order: :orders)
    else
      flash[:alert] = @order.errors.full_messages.join(", ")
      redirect_to users_profile_path(order: :orders)
    end
  end
end
