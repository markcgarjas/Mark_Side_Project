class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  enum role: { client: 0, admin: 1 }
  validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }, length: { maximum: 13 }
  mount_uploader :image, ImageUploader
  validates :coins, numericality: { greater_than_or_equal_to: 0 }
  validates :username, allow_blank: true, length: { minimum: 6 }, uniqueness: true, on: :update
  has_many :addresses
  belongs_to :parent, class_name: "User", optional: true, counter_cache: :children_members
  has_many :children, class_name: "User", foreign_key: 'parent_id'
  has_many :bets
  has_many :winners
  has_many :orders
  has_many :news_tickers, foreign_key: 'admin_id'
  belongs_to :member_level, optional: true
  after_create :check_level_up

  def check_level_up
    return unless parent.present?
    member = MemberLevel.find_by(required_members: parent.children_members)
    if member.present?
      parent.update(coins: parent.coins + member.coins, member_level: member)
    end
  end

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = rand(12).to_s + provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
