class Address::Barangay < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  belongs_to :city_municipality, optional: true
end
