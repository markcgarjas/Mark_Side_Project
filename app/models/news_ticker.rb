class NewsTicker < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :content,
            :status,
            :sort, presence: true
  enum status: { active: 0, inactive: 1 }
  belongs_to :admin, class_name: "User"
  default_scope { order(:sort, :status) }

  def destroy
    update(deleted_at: Time.current)
  end
end
