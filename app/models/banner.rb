class Banner < ApplicationRecord
  validates :preview,
            :online_at,
            :offline_at,
            :sort, presence: true
  enum status: { active: 0, inactive: 1 }
  mount_uploader :preview, ImageUploader
  default_scope { order(:sort, :status) }
end
