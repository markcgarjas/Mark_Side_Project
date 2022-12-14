class Offer < ApplicationRecord
  validates :name, presence: true
  validates :image, presence: true
  validates :coin, presence: true
  validates :amount, presence: true
  validates :genre, presence: true
  validates :status, presence: true

  mount_uploader :image, ImageUploader

  enum genre: { one_time: 0, monthly: 1, weekly: 2, daily: 3, regular: 4 }
  enum status: { inactive: 0, active: 1 }
end
