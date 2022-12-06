class Admins::UsersController < AdminController
  before_action :check_admin

  def index
    @users = User.where(role: 0)
  end

  private

  def check_admin
    raise ActionController::RoutingError.new('Not Found') unless current_admins_user
  end
end
