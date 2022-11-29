class Address::CityMunicipality < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  belongs_to :province, optional: true
  belongs_to :district
  has_many :barangays
end
