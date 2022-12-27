class Admins::BetsController < AdminController
  before_action :set_action, only: :cancel_bet

  def index
    @bets = Bet.includes(:user, :item).all
    @bets = @bets.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.where(user: { email: params[:email] }) if params[:email].present?
    @bets = @bets.where state: params[:state] if params[:state].present?
    @bets = @bets.where(item: { name: params[:item_name] }) if params[:item_name].present?
    @bets = @bets.where('bets.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @bets = @bets.where('bets.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
    respond_to do |format|
      format.html
      format.csv {
        csv_strings = CSV.generate do |csv|
          csv << [Bet.human_attribute_name(:serial_number),
                  Bet.human_attribute_name(:item_name),
                  Bet.human_attribute_name(:email),
                  Bet.human_attribute_name(:coins),
                  Bet.human_attribute_name(:state),
                  Bet.human_attribute_name(:date)]
          @bets.each do |bet|
            csv << [bet.serial_number,
                    bet.item.name,
                    bet.user.email,
                    bet.coins,
                    bet.state,
                    bet.created_at]
          end
        end
        send_data csv_strings, :filename => "Bet Lists-#{Time.current.to_s}.csv"
      }
    end
  end

  def cancel_bet
    if @bet.cancel!
      flash[:notice] = "#{@bet.serial_number} Cancelled"
      redirect_to admins_bets_path
    else
      flash[:notice] = @bet.errors.full_messages.join(", ")
      redirect_to admins_bets_path
    end
  end

  private

  def set_action
    @bet = Bet.find(params[:bet_id])
  end
end
