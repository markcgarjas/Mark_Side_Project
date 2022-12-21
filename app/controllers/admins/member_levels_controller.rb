class Admins::MemberLevelsController < AdminController
  before_action :set_member_level, only: [:edit, :update, :destroy]

  def index
    @member_levels = MemberLevel.includes(:users).all
  end

  def new
    @member_level = MemberLevel.new
  end

  def create
    @member_level = MemberLevel.new(member_level_params)
    # @member_level.user = User.first
    if @member_level.save
      flash[:notice] = "Successfully Created"
      redirect_to admins_member_levels_path
    else
      flash[:notice] = @member_level.errors.full_messages.join(", ")
      redirect_to new_admins_member_level_path
    end
  end

  def edit; end

  def update
    @member_level.update(member_level_params)
    if @member_level.save
      flash[:notice] = "Successfully Updated"
      redirect_to admins_member_levels_path
    else
      flash[:notice] = @member_level.errors.full_messages.join(", ")
      redirect_to edit_admins_member_level_path
    end
  end

  def destroy
    if @member_level.destroy
      flash[:notice] = "Successfully Deleted"
      redirect_to admins_member_levels_path
    else
      flash[:notice] = @member_level.errors.full_messages.join(", ")
      redirect_to edit_admins_member_level_path
    end
  end

  private

  def member_level_params
    params.require(:member_level).permit(:level, :coins, :required_members)
  end

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end
end
