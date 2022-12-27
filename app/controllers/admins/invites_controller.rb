class Admins::InvitesController < AdminController
  def index
    @users = User.includes(:bets, :parent).where.not(parent: nil? || 0)
    @users = @users.where(parent: { email: params[:parent_email] }) if params[:parent_email].present?
    respond_to do |format|
      format.html
      format.csv {
        csv_strings = CSV.generate do |csv|
          csv << [User.human_attribute_name(:parent_email),
                  User.human_attribute_name(:email),
                  User.human_attribute_name(:total_deposit),
                  User.human_attribute_name(:member_total_deposits),
                  User.human_attribute_name(:coins),
                  User.human_attribute_name(:created_at),
                  User.human_attribute_name(:coins_used_count),
                  User.human_attribute_name(:children_members)]
          @users.each do |user|
            csv << [user.parent&.email,
                    user.email,
                    user.total_deposit,
                    user.children.sum(:total_deposit),
                    user.coins,
                    user.created_at,
                    user.bets.where.not(state: :cancelled).count,
                    user.children_members]
          end
        end
        send_data csv_strings, :filename => "Invite Lists-#{Time.current.to_s}.csv"
      }
    end
  end
end
