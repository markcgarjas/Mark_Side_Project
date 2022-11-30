class UpdateAddress < ActiveRecord::Migration[7.0]
  def down
    drop_table :address_districts
  end
end
