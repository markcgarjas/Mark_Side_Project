class Users::FeedbackController < ApplicationController
  def show
    @user = current_user
    @winner = Winner.includes(:item, :bet, :address).where(user: @user).find(params[:id])
    @addresses = Address.where(user: @user)
  end

  def update
    @user = current_user
    @winner = Winner.where(user: @user).find(params[:id])
    if @winner.update(winner_params)
      @winner.share!
      @winner.save
      flash[:notice] = "#{@winner.item.name} successfully Feedback"
      redirect_to users_profile_path(winner: :winners)
    else
      render :show
    end
  end

  private

  def winner_params
    params.require(:winner).permit(:comment, :picture)
  end
end
