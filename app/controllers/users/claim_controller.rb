class Users::ClaimController < ApplicationController
  def show
    @winner = Winner.includes(:item, :bet, :address).where(user: current_user).find(params[:id])
    @addresses = Address.where(user: current_user)
  end

  def update
    @winner = Winner.where(user: current_user).find(params[:id])
    if @winner.update(winner_params)
      @winner.claim!
      @winner.save
      flash[:notice] = t("update_successfully")
      redirect_to users_profile_path(winner: :winners)
    else
      flash[:alert] = @winner.errors.full_messages.join(", ")
      redirect_to users_claim_path
    end
  end

  private

  def winner_params
    params.require(:winner).permit(:address_id)
  end
end
