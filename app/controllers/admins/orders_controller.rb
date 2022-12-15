class Admins::OrdersController < AdminController
  before_action :set_order, only: [:pay_event, :cancel_event]

  def index
    @orders = Order.includes(:user, :offer).all
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(user: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @orders.where(state: params[:state]) if params[:state].present?
    @orders = @orders.where(offer: { name: params[:name] }) if params[:name].present?
    @orders = @orders.where('orders.created_at >= ?', params[:created_at]) if params[:created_at].present?
    @orders = @orders.where('orders.created_at <= ?', params[:ended_at]) if params[:ended_at].present?
  end

  def pay_event
    if @order.may_pay?
      @order.pay!
      flash[:notice] = "Successfully Paid"
      redirect_to admins_orders_path
    else
      flash[:notice] = "Error when Paid"
      redirect_to admins_orders_path
    end
  end

  def cancel_event
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Successfully Cancelled"
      redirect_to admins_orders_path
    else
      flash[:notice] = "Error when cancel"
      redirect_to admins_orders_path
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end