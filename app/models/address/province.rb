class Address::Province < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  belongs_to :region
  has_many :city_municipalities
end
