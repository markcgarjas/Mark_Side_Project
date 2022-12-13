class Admins::WinnersController < AdminController
  before_action :set_winner_event, only: [:submit_event, :pay_event, :ship_event, :deliver_event, :publish_event, :remove_publish_event]

  def index
    @winners = Winner.includes(:user, :item, :bet).all
    @winners = @winners.where(bet: { serial_number: params[:serial_number] }) if params[:serial_number].present?
    @winners = @winners.where(user: { email: params[:email] }) if params[:email].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?
    @winners = @winners.where('winners.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @winners = @winners.where('winners.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
  end

  def submit_event
    @winner.submit!
    flash[:notice] = "#{@winner.serial_number} Cancelled"
    redirect_to admins_bets_path
  end

  def pay_event
    @winner.pay!
    flash[:notice] = "#{@winner.serial_number} Paid"
    redirect_to admins_bets_path
  end

  def ship_event
    @winner.ship!
    flash[:notice] = "#{@winner.serial_number} Shipped"
    redirect_to admins_bets_path
  end

  def deliver_event
    @winner.deliver!
    flash[:notice] = "#{@winner.serial_number} Delivered"
    redirect_to admins_bets_path
  end

  def publish_event
    @winner.publish!
    flash[:notice] = "#{@winner.serial_number} Published"
    redirect_to admins_bets_path
  end

  def remove_publish_event
    @winner.remove_publish!
    flash[:notice] = "#{@winner.serial_number} Remove Published"
    redirect_to admins_bets_path
  end

  private

  def set_winner_event
    @winner = Winner.find(params[:winner_id])
  end
end