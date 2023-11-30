class Storefront < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true, length: {maximum: 75}
  validates :short_description, presence: true, length: {maximum: 500}
end
