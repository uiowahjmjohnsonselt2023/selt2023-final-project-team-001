class User < ApplicationRecord
  attr_accessor :session_token
  has_secure_password
  before_save { |user| user.email = user.email.downcase }
  before_save :create_session_token
  # If a user's is_seller attribute is changed to true, make sure they have a profile.
  # This has to be after a commit because (for new users) we need to save the user
  # before we can create a profile for them.
  after_save_commit :update_profile_visibility,
    if: [:saved_change_to_is_seller?, :is_seller?]

  validates :first_name, presence: true, length: {maximum: 50}
  validates :last_name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,24})\z/i
  validates :email, presence: true,
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  # allow_nil allows us to update a user without changing their password. Note that
  # this doesn't allow us to create a user without a password, since has_secure_password
  # requires a password on creation. See https://stackoverflow.com/a/45329148
  validates :password, presence: true, length: {minimum: 8}, allow_nil: true
  validates :password_confirmation, presence: true, length: {minimum: 8}, on: :create
  validate :password_is_secure

  def password_is_secure
    unless /[A-Z]/.match?(password)
      errors.add(:password, "must contain at least one capital letter")
    end
    unless /[!@#$%^&*(),.?":{}|<>]/.match?(password)
      errors.add(:password, "must contain at least one special character")
    end
    unless /[0-9]/.match?(password)
      errors.add(:password, "must contain at least one number")
    end
  end

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
  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart
  has_many :reviews_user_has_given, class_name: "Review", foreign_key: :reviewer_id, dependent: :destroy
  has_many :reviews_for_sellers, class_name: "Review", foreign_key: :seller_id, dependent: :destroy
  has_many :cart_products, through: :carts, source: :product
  has_many :viewed_products
  has_many :viewed, through: :viewed_products, source: :product
  accepts_nested_attributes_for :profile  # If you want to handle profile attributes in user forms
  has_one :storefront, dependent: :destroy
  accepts_nested_attributes_for :storefront
  has_many :promotions, foreign_key: :seller_id, dependent: :destroy
  has_many :messages_sent, class_name: "Message", foreign_key: :sender_id, dependent: :destroy
  has_many :messages_received, class_name: "Message", foreign_key: :receiver_id, dependent: :destroy
  has_many :price_alerts, dependent: :destroy

  # Override the is_admin setter so that all admins are sellers and buyers.
  def is_admin=(value)
    super(value)
    self.is_seller ||= value
    self.is_buyer ||= value
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end

  def update_profile_visibility
    if is_seller? && (profile.nil? || !profile.public_profile)
      build_profile(public_profile: true) unless profile
      profile.update(public_profile: true)
    end
  end
end
