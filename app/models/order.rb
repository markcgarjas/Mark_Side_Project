class Order < ApplicationRecord
  include AASM
  validates :coin, presence: true, numericality: { greater_than: 0 }
  validates :remarks, presence: true, unless: [:member_level?, :deposit?]
  belongs_to :offer, optional: true
  belongs_to :user
  after_create :generate_serial_number

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4, member_level: 5 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, guard: :enough_coins?, after: [:cancel_deduction, :decrease_total_deposit]
    end

    event :pay do
      transitions from: :submitted, to: :paid, guard: :not_deduct?, after: [:pay_deduction, :increase_total_deposit]
      transitions from: :submitted, to: :paid, guard: :enough_coins?, after: [:pay_deduction, :increase_total_deposit]
    end
  end

  def pay_deduction
    if deduct?
      self.user.update(coins: self.user.coins - coin)
    else
      self.user.update(coins: self.user.coins + coin)
    end
  end

  def cancel_deduction
    if deduct?
      self.user.update(coins: self.user.coins + coin)
    else
      self.user.update(coins: self.user.coins - coin)
    end
  end

  def not_deduct?
    !deduct?
  end

  def decrease_total_deposit
    if deposit?
      self.user.update(total_deposit: self.user.total_deposit - amount)
    end
  end

  def increase_total_deposit
    if deposit?
      self.user.update(total_deposit: self.user.total_deposit + amount)
    end
  end

  def generate_serial_number
    number_count = Order.where(user_id: user_id).count.to_s.rjust(4, '0')
    self.update(serial_number: "#{Time.current.strftime("%y%m%d")}-#{id}-#{user_id}-#{number_count}")
  end

  def enough_coins?
    self.user.coins >= coin
  end

  def enough_total_deposit?
    if deposit?
      amount >= 1
    end
  end
end
