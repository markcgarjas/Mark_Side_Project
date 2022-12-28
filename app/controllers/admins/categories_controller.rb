class Admins::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params_category)
    if @category.save
      flash[:notice] = "Create Successfully"
      redirect_to admins_categories_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(params_category)
      flash[:notice] = "Update Successfully"
      redirect_to admins_categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = "Delete Successfully"
      redirect_to admins_categories_path
    else
      flash[:notice] = @category.errors.full_messages.join(", ")
      redirect_to admins_categories_path
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def params_category
    params.require(:category).permit(:name, :sort)
  end
end
