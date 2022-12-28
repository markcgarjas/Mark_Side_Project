class Banner < ApplicationRecord
  validates :preview,
            :online_at,
            :offline_at,
            :status, presence: true
  validates :sort, presence: true, numericality: { greater_than: 0 }
  enum status: { active: 0, inactive: 1 }
  mount_uploader :preview, ImageUploader
  default_scope { order(:sort, :status) }
end
