class User < ApplicationRecord
  has_secure_password

  # Scopes allow us to write things like User.admins to get all admins
  # or User.non_sellers to get all users who aren't sellers.
  scope :admins, -> { where(is_admin: true) }
  scope :non_admins, -> { where(is_admin: false) }
  scope :sellers, -> { where(is_seller: true) }
  scope :non_sellers, -> { where(is_seller: false) }
  scope :buyers, -> { where(is_buyer: true) }
  scope :non_buyers, -> { where(is_buyer: false) }
end
