class Users::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]
  before_action :set_user

  def index
    @addresses = current_user.addresses.includes(:user, :region, :province, :city_municipality, :barangay)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user = current_user
    if @address.save
      flash[:notice] = t("create_successfully")
      redirect_to users_profile_addresses_path
    else
      flash[:alert] = @address.errors.full_messages.join(", ")
      redirect_to new_users_profile_address_path
    end
  end

  def edit; end

  def update
    @address.update(address_params)
    @address.user = current_user
    if @address.save
      flash[:notice] = t("update_successfully")
      redirect_to users_profile_addresses_path
    else
      flash[:alert] = @address.errors.full_messages.join(", ")
      redirect_to new_users_profile_address_path
    end
  end

  def destroy
    if @address.destroy
      flash[:notice] = t("delete_successfully")
      redirect_to users_profile_addresses_path
    else
      flash[:alert] = @address.errors.full_messages.join(", ")
      redirect_to new_users_profile_address_path
    end
  end

  private

  def address_params
    params.require(:address).permit(:name, :genre, :street, :phone, :is_default, :remark, :address_region_id, :address_province_id, :address_city_municipality_id, :address_barangay_id)
  end

  def set_user
    @user = current_user
  end

  def set_address
    @address = current_user.addresses.find(params[:id])
  end
end

