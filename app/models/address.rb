class Address < ApplicationRecord

  ADDRESS_LIMIT = 5
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'address_region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'address_province_id'
  belongs_to :city_municipality, class_name: 'Address::CityMunicipality', foreign_key: 'address_city_municipality_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'address_barangay_id'
  has_many :winners
  validate :address_limit, on: :create
  validates :genre, presence: true
  validates :name, presence: true
  validates :street, presence: true
  validates :phone, phone: { possible: true, allow_blank: true, types: [:voip, :mobile], countries: :ph }, length: { maximum: 13 }
  enum genre: { Home: 0, Office: 1 }
  after_save :only_one_default_address
  before_create :default_address_when_empty

  def address_concat
    "#{street}, #{region&.name}, #{province&.name}, #{city_municipality&.name}, #{barangay&.name}"
  end

  private

  def address_limit
    if self.user.addresses.reload.count >= ADDRESS_LIMIT
      errors.add(:base, "You are on the limit delete 1 address to create!")
    end
  end

  def only_one_default_address
    if is_default
      user.addresses.where('id != ?', id).update_all(is_default: false)
    end
  end

  def default_address_when_empty
    if user.addresses.empty?
      self.is_default = true
    else
      self.is_default = false
    end
  end
end
