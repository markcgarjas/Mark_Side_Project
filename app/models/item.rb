class Item < ApplicationRecord
  include AASM
  default_scope { where(deleted_at: nil) }

  validates :image, presence: true
  validates :name, presence: true
  validates :minimum_bets, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :start_at, presence: true
  validates :status, presence: true
  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships
  has_many :bets

  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }

  def destroy
    update(deleted_at: Time.current)
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting,
                  guards: [:quantity_enough?, :status_is_active?, :offline_at_present_day?],
                  success: :update_quantity_and_batch_count
      transitions from: :pending, to: :starting
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: [:pending, :starting], to: :ended
      transitions from: :start, to: :ended, after: :update_status
    end

    event :cancel do
      transitions from: [:pending, :starting], to: :cancelled, after: :update_quantity_when_cancel
    end
  end

  def update_quantity_and_batch_count
    self.update(quantity: self.quantity - 1, batch_count: self.batch_count + 1)

  end

  def update_quantity_when_cancel
    self.update(quantity: self.quantity + 1)
  end

  def quantity_enough?
    self.quantity >= 1
  end

  def offline_at_present_day?
    self.offline_at > Time.current
  end

  def status_is_active?
    self.status == "active"
  end
end
