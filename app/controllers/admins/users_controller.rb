class Admins::UsersController < AdminController
  def index
    @users = User.includes(:bets).where(role: 0)
    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [User.human_attribute_name(:parent_email),
                  User.human_attribute_name(:email),
                  User.human_attribute_name(:total_deposit),
                  User.human_attribute_name(:member_total_deposits),
                  User.human_attribute_name(:coins),
                  User.human_attribute_name(:total_used_coins),
                  User.human_attribute_name(:children_members),
                  User.human_attribute_name(:phone)]
          @users.each do |user|
            csv << [user.parent&.email,
                    user.email,
                    user.total_deposit,
                    user.children.sum(:total_deposit),
                    user.coins,
                    user.bets.where.not(state: :cancelled).count,
                    user.children_members,
                    user.phone]
          end
        end
        send_data csv_string, :filename => "User Lists-#{Time.current.to_s}.csv"
      }
    end
  end
end