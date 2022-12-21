class Admins::WinnersController < AdminController
  before_action :set_winner_event, only: [:submit_event, :pay_event, :ship_event, :deliver_event,
                                          :share_event, :publish_event, :remove_publish_event]

  def index
    @winners = Winner.includes(:user, :item, :bet).all
    @winners = @winners.where(bet: { serial_number: params[:serial_number] }) if params[:serial_number].present?
    @winners = @winners.where(user: { email: params[:email] }) if params[:email].present?
    @winners = @winners.where(state: params[:state]) if params[:state].present?
    @winners = @winners.where('winners.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @winners = @winners.where('winners.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
  end

  def submit_event
    if @winner.submit!
      flash[:notice] = "#{@winner.bet.serial_number} Submitted"
      redirect_to admins_winners_path
    else
      flash[:notice] = @winner.errors.full_messages.join(", ")
      redirect_to admins_winners_path
    end
  end

  def pay_event
    if @winner.pay!
      flash[:notice] = "#{@winner.bet.serial_number} Paid"
      redirect_to admins_winners_path
    else
      flash[:notice] = @winner.errors.full_messages.join(", ")
      redirect_to admins_winners_path
    end
  end

  def ship_event
    if @winner.ship!
      flash[:notice] = "#{@winner.bet.serial_number} Shipped"
      redirect_to admins_winners_path
    else
      flash[:notice] = @winner.errors.full_messages.join(", ")
      redirect_to admins_winners_path
    end
  end

  def deliver_event
    if @winner.deliver!
      flash[:notice] = "#{@winner.bet.serial_number} Delivered"
      redirect_to admins_winners_path
    else
      flash[:notice] = @winner.errors.full_messages.join(", ")
      redirect_to admins_winners_path
    end
  end

  def share_event
    if @winner.share!
      flash[:notice] = "#{@winner.bet.serial_number} Shared"
      redirect_to admins_winners_path
    else
      flash[:notice] = @winner.errors.full_messages.join(", ")
      redirect_to admins_winners_path
    end
  end

  def publish_event
    if @winner.publish!
      flash[:notice] = "#{@winner.bet.serial_number} Published"
      redirect_to admins_winners_path
    else
      flash[:notice] = @winner.errors.full_messages.join(", ")
      redirect_to admins_winners_path
    end
  end

  def remove_publish_event
    if @winner.remove_publish!
      flash[:notice] = "#{@winner.bet.serial_number} Remove Published"
      redirect_to admins_winners_path
    else
      flash[:notice] = @winner.errors.full_messages.join(", ")
      redirect_to admins_winners_path
    end
  end

  private

  def set_winner_event
    @winner = Winner.find(params[:winner_id])
  end
end