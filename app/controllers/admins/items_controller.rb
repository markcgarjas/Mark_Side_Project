class Admins::ItemsController < AdminController
  before_action :set_item_params, only: [:destroy, :edit, :show, :update]

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
      render :new
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
      render :edit
    end
  end

  def destroy
    @item.destroy
    redirect_to admins_items_path
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end

  def set_item_params
    @item = Item.find(params[:id])
  end
end
