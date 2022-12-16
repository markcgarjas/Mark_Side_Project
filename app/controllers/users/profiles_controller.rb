class Users::ProfilesController < ApplicationController
  def show
    @user = current_user
    @orders = Order.where(user: @user) if params[:order] == 'orders'
    @winners = Winner.where(user: @user) if params[:winner] == 'winners'
    @lotteries = Bet.where(user: @user) if params[:lottery] == 'lotteries'
    @invitations = User.where(parent: @user) if params[:invitation] == 'invitations'
  end
end
