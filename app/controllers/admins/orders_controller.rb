class Admins::OrdersController < AdminController
  before_action :set_order, only: [:pay_event, :cancel_event]
  before_action :set_user, only: [:new, :create]

  def index
    @orders = Order.includes(:user, :offer).all
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(user: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer: { name: params[:name] }) if params[:name].present?
    @orders = @orders.where('orders.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @orders = @orders.where('orders.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
    @total_amount = Order.sum(:amount)
    @total_coin = Order.sum(:coin)
    @subtotal_amount = @orders.sum(:amount)
    @subtotal_coin = @orders.sum(:coin)
    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [Order.human_attribute_name(:serial_number),
                  Order.human_attribute_name(:email),
                  Order.human_attribute_name(:genre),
                  Order.human_attribute_name(:state),
                  Order.human_attribute_name(:offer_name),
                  Order.human_attribute_name(:amount),
                  Order.human_attribute_name(:coins),
                  Order.human_attribute_name(:created_at),
          ]
          @orders.each do |order|
            csv << [order.serial_number,
                    order.user.email,
                    order.genre,
                    order.state,
                    order.offer&.name,
                    order.amount,
                    order.coin,
                    order.created_at]
          end
        end
        send_data csv_string, :filename => "Order Lists-#{Time.current.to_s}.csv"
      }
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = @user
    @order.genre = params[:genre]
    if @order.save
      if @order.submit! && @order.may_pay? && @order.pay!
        flash[:notice] = "Successfully Created"
        redirect_to admins_user_new_path
      else
        @order.cancel!
        flash[:notice] = "You can't deduct user coins"
          render :new
      end
    else
      render :new
    end
  end

  def pay_event
    if @order.may_pay?
      @order.pay!
      flash[:notice] = "Successfully Paid"
      redirect_to admins_orders_path
    else
      flash[:alert] = @order.errors.full_messages.join(", ")
      redirect_to admins_orders_path
    end
  end

  def cancel_event
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Successfully Cancelled"
      redirect_to admins_orders_path
    else
      flash[:alert] = @order.errors.full_messages.join(", ")
      redirect_to admins_orders_path
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end
end
