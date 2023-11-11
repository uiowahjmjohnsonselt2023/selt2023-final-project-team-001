class Profile < ApplicationRecord
  belongs_to :user
  mount_uploader :avatar, AvatarUploader

  validates :website, format: {with: URI::DEFAULT_PARSER.make_regexp, message: "is not a valid URL"}, allow_blank: true
  validates :twitter, format: {with: %r{\A(?:https?://)?(?:www\.)?x\.com/.*?\z}, message: "is not a valid Twitter link"}, allow_blank: true
  validates :facebook, format: {with: %r{\A(?:https?://)?(?:www\.)?facebook\.com/.*?\z}, message: "is not a valid Facebook link"}, allow_blank: true
  validates :instagram, format: {with: %r{\A(?:https?://)?(?:www\.)?instagram\.com/.*?\z}, message: "is not a valid Instagram link"}, allow_blank: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
