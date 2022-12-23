class Admins::UsersController < AdminController
  def index
    @users = User.includes(:bets).where(role: 0)
  end
end
