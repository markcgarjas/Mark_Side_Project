class Users::FeedbackController < ApplicationController
  def show
    @winner = Winner.includes(:item, :bet, :address).where(user: current_user).find(params[:id])
    @addresses = Address.where(user: current_user)
  end

  def update
    @winner = Winner.where(user: current_user).find(params[:id])
    if @winner.update(winner_params)
      @winner.share!
      @winner.save
      flash[:notice] = t("update_successfully")
      redirect_to users_profile_path(winner: :winners)
    else
      flash[:alert] = @winner.errors.full_messages.join(", ")
      redirect_to users_feedback_path
    end
  end

  private

  def winner_params
    params.require(:winner).permit(:comment, :picture)
  end
end
