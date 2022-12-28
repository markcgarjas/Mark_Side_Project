class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :sort, presence: true
  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :items, through: :item_category_ships
  default_scope { order(:sort) }
end
