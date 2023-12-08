class Profile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  # If public_profile was set to false, make sure it's kept to true for sellers.
  before_validation :set_public_if_seller,
    if: [:user, :public_profile_changed?],
    unless: :public_profile

  validates :website, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URL"}, allow_blank: true
  validates :twitter, format: {with: %r{\A(?:https?://)?(?:www\.)?x\.com/.*?\z}, message: "is not a valid Twitter link"}, allow_blank: true
  validates :facebook, format: {with: %r{\A(?:https?://)?(?:www\.)?facebook\.com/.*?\z}, message: "is not a valid Facebook link"}, allow_blank: true
  validates :instagram, format: {with: %r{\A(?:https?://)?(?:www\.)?instagram\.com/.*?\z}, message: "is not a valid Instagram link"}, allow_blank: true
  # validate (singular!) is used for custom validations
  validate :sellers_have_public_profiles

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def set_public_if_seller
    self.public_profile = user.is_seller
  end

  def sellers_have_public_profiles
    if user&.is_seller && !public_profile
      errors.add(:public_profile, "must be true for sellers")
    end
  end
end
