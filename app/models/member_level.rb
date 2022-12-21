class MemberLevel < ApplicationRecord
  validates :coins, presence: true, numericality: { greater_than: 0 }
  validates :required_members, presence: true, uniqueness: true
  validates :level, presence: true, uniqueness: true
  has_many :users

  default_scope {order(:required_members)}

end
