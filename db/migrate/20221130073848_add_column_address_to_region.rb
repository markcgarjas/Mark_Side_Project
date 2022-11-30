class AddColumnAddressToRegion < ActiveRecord::Migration[7.0]
  def change
    remove_reference :address_city_municipalities, :district
    add_column :address_regions, :region_name, :string
  end
end
