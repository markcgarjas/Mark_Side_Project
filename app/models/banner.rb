class Banner < ApplicationRecord
  validates :preview,
            :online_at,
            :offline_at, presence: true
  enum status: { active: 1, inactive: 0 }
  mount_uploader :preview, ImageUploader
end
