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
  has_many :winners

  mount_uploader :image, ImageUploader

  enum status: { inactive: 0, active: 1 }

  def destroy
    unless bets.present?
      update(deleted_at: Time.current)
    end
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting,
                  guards: [:quantity_enough?, :active?, :offline_at_present_day?],
                  success: :update_quantity_and_batch_count
      transitions from: :pending, to: :starting
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, guard: :minimum_bet?, after: :raffle
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

  def minimum_bet?
    self.minimum_bets <= bets.where(batch_count: batch_count, state: :betting).count
  end

  def raffle
    list = bets.where(batch_count: batch_count, state: :betting)
    winner_bet = list.sample
    winner_bet.win!
    list.where.not(id: winner_bet.id).update_all(state: :lost)
    winners.new(user: winner_bet.user, item_batch_count: batch_count, address: winner_bet.user.addresses.find_by(is_default: true), bet: winner_bet, admin: User.all.find_by(role: 1)).save!
  end
end

