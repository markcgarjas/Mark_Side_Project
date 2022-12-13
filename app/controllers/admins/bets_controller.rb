class Admins::BetsController < AdminController
  def index
    @bets = Bet.includes(:user, :item).all
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(user: { email: params[:email] }) if params[:email].present?
    @bets = @bets.where state: params[:state] if params[:state].present?
    @bets = @bets.where(item: { name: params[:item_name] }) if params[:item_name].present?
    @bets = @bets.where('bets.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @bets = @bets.where('bets.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
  end

  def cancel_bet
    @bet = Bet.find(params[:bet_id])
    @bet.cancel!
    flash[:notice] = "#{@bet.serial_number} Cancelled"
    redirect_to admins_bets_path
  end
end
