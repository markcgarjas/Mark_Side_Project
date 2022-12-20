class NewsTicker < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :content, presence: true
  validates :status, presence: true
  enum status: { active: 1, inactive: 0 }
  belongs_to :admin, class_name: "User"

  def destroy
    update(deleted_at: Time.current)
  end
end
