class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: { client: 0, admin: 1 }
  validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }, length: { maximum: 13 }
  mount_uploader :image, ImageUploader
end
