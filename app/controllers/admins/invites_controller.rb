class Admins::InvitesController < AdminController
  def index
    @users = User.includes(:bets, :parent).where.not(parent: nil? || 0)
    @users = @users.where(parent: { email: params[:parent_email] }) if params[:parent_email].present?
  end
end
