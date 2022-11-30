class Address::CityMunicipality < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  belongs_to :province, optional: true
  has_many :barangays
end
