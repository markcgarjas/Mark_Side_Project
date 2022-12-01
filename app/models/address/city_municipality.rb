class Address::CityMunicipality < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  belongs_to :province, optional: true
  has_many :barangays
  has_many :addresses, class_name: 'Address', foreign_key: 'address_city_municipality_id'
end
