class Admins::ItemsController < AdminController
  before_action :set_item, only: [:destroy, :edit, :show, :update]
  before_action :set_item_event, only: [:start_event, :end_event, :pause_event, :cancel_event]

  def index
    @items = Item.includes(:categories).all
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "Create Successfully"
      redirect_to admins_items_path
    else
      flash[:notice] = @item.errors.full_messages.join(", ")
      redirect_to new_admins_item_path
    end
  end

  def show; end

  def edit; end

  def update
    @item.update(item_params)
    if @item.save
      flash[:notice] = "Update Successfully"
      redirect_to admins_items_path
    else
      flash[:notice] = @item.errors.full_messages.join(", ")
      redirect_to edit_admins_item_path
    end
  end

  def destroy
    if @item.destroy
      flash[:notice] = "#{@item.name} Deleted"
      redirect_to admins_items_path
    else
      flash[:notice] = @item.errors.full_messages.join(", ")
      redirect_to admins_items_path
    end
  end

  def start_event
    if @item.may_start?
      flash[:notice] = "#{@item.name} Started"
      redirect_to admins_items_path
      @item.start!
    else
      flash[:notice] = "You cant start"
      redirect_to admins_items_path
    end
  end

  def end_event
    if @item.may_end?
      @item.end!
      flash[:notice] = "#{@item.name} Ended! We have one lucky winner!"
      redirect_to admins_items_path
    else
      flash[:notice] = @item.errors.full_messages.join(", ")
      redirect_to admins_items_path
    end
  end

  def pause_event
    if @item.may_pause?
      @item.pause!
      flash[:notice] = "#{@item.name} Paused"
      redirect_to admins_items_path
    else
      flash[:notice] = @item.errors.full_messages.join(", ")
      redirect_to admins_items_path
    end
  end

  def cancel_event
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = "#{@item.name} Cancelled"
      redirect_to admins_items_path
    else
      flash[:notice] = @item.errors.full_messages.join(", ")
      redirect_to admins_items_path
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_item_event
    @item = Item.find(params[:item_id])
  end
end
