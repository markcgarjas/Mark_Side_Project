class Bet < ApplicationRecord
  include AASM

  validates :coins, numericality: { greater_than: 0 }
  belongs_to :user
  belongs_to :item
  after_create :minus_coins, :generate_serial_number
  after_validation :coins_enough?
  after_validation :minimum_bet?

  aasm column: :state do
    state :betting, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :betting, to: :won
    end

    event :lose do
      transitions from: :betting, to: :lost
    end

    event :cancel do
      transitions from: :betting, to: :cancelled, after: :coins_back
    end
  end

  def coins_back
    self.user.update(coins: self.user.coins + 1)
  end

  def minus_coins
    self.user.update(coins: self.user.coins - 1)
  end

  def generate_serial_number
    number_count = Bet.where(batch_count: batch_count, item_id: item_id).count.to_s.rjust(4, '0')
    self.update(serial_number: "#{Time.current.strftime("%y%m%d")}-#{item.id}-#{item.batch_count}-#{number_count}")
  end

  def coins_enough?
    if self.user.coins < 1
      errors.add(:base, "You dont have enough coins")
    end
  end

  def minimum_bet?
    if self.item.minimum_bets > self.user.coins
      errors.add(:base, "The minimum bet is #{self.item.minimum_bets}")
    end
  end
end
