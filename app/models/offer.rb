class Offer < ApplicationRecord
  validates :name, presence: true
  validates :image, presence: true
  validates :coin, presence: true, numericality: { greater_than: 0 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :genre, presence: true
  validates :status, presence: true
  has_many :orders

  mount_uploader :image, ImageUploader

  enum genre: { one_time: 0, monthly: 1, weekly: 2, daily: 3, regular: 4 }
  enum status: { inactive: 0, active: 1 }
end
