class UpdateColumnUser < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :coins, :integer, default: 0
    change_column :users, :total_deposit, :integer, default: 0, precision: 10
    remove_column :users, :childer_members
    add_column :users, :children_members, :integer, default: 0
  end
end
