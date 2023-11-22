class User < ApplicationRecord
  attr_accessor :session_token
  has_secure_password
  before_save { |user| user.email = user.email.downcase }
  before_save :create_session_token
  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,24})\z/i
  validates :email, presence: true,
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 8}
  validates :password_confirmation, presence: true, length: {minimum: 8}

  # Scopes allow us to write things like User.admins to get all admins
  # or User.non_sellers to get all users who aren't sellers.
  scope :admins, -> { where(is_admin: true) }
  scope :non_admins, -> { where(is_admin: false) }
  scope :sellers, -> { where(is_seller: true) }
  scope :non_sellers, -> { where(is_seller: false) }
  scope :buyers, -> { where(is_buyer: true) }
  scope :non_buyers, -> { where(is_buyer: false) }

  has_many :products, foreign_key: :seller_id, dependent: :destroy
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile  # If you want to handle profile attributes in user forms

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end
end
