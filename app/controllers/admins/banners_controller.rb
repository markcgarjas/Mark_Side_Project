class Admins::BannersController < AdminController
  before_action :set_banner, only: [:edit, :update, :destroy]

  def index
    @banners = Banner.all
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      flash[:notice] = "Successfully Created"
      redirect_to admins_banners_path
    else
      flash[:notice] = @banner.errors.full_messages.join(", ")
      redirect_to new_admins_banner_path
    end
  end

  def edit; end

  def update
    @banner.update(banner_params)
    if @banner.save
      flash[:notice] = "Successfully Updated"
      redirect_to admins_banners_path
    else
      flash[:notice] = @banner.errors.full_messages.join(", ")
      redirect_to new_admins_banner_path
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = "Successfully Deleted"
      redirect_to admins_banners_path
    else
      flash[:notice] = @banner.errors.full_messages.join(", ")
      redirect_to new_admins_banner_path
    end
  end

  private

  def banner_params
    params.require(:banner).permit(:preview, :online_at, :offline_at, :status, :sort)
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end
end
