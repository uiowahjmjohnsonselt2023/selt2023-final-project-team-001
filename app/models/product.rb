class Product < ApplicationRecord
  REQUIRED_FIELDS = %i[name description price quantity condition].freeze

  belongs_to :seller, class_name: "User"
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  # Left 100 between each value to allow for future additions.
  # Taken from https://www.recycledcycles.com/service/used-item-condition-guide/
  enum :condition,
    # DO NOT change these values.
    {poor: 0, fair: 100, good: 200, excellent: 300, new: 400},
    suffix: true,
    validate: true
  # monetize makes the price_cents attribute accessible as price and price=.
  # price is a Money object, which has a currency and a value.
  monetize :price_cents, numericality: {greater_than: 0}

  validates(*REQUIRED_FIELDS, presence: true) # parentheses required for splat operator
  validates :name, length: {maximum: 100}
  validates :description, length: {maximum: 1000}
  validates :quantity, numericality: {greater_than: 0}
  validates :private, inclusion: {in: [true, false]}
end
