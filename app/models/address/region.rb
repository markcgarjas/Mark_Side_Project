class Address::Region < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  has_many :provinces
  has_many :addresses, class_name: 'Address', foreign_key: 'address_region_id'
end
