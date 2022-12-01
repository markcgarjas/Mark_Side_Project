class Address::Barangay < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  belongs_to :city_municipality, optional: true
  has_many :addresses, class_name: 'Address', foreign_key: 'address_barangay_id'
end
