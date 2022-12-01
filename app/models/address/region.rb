class Address::Region < ApplicationRecord
  validates :code, uniqueness: true
  validates :name, presence: true

  has_many :provinces
end
