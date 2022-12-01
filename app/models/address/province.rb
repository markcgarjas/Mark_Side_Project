class Address::Province < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  belongs_to :region
  has_many :city_municipalities
  has_many :addresses, class_name: 'Address', foreign_key: 'address_province_id'
end
