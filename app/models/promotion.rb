class Promotion < ApplicationRecord
  TYPES = %w[
    Promotions::PercentOff
    Promotions::FixedAmountOff
  ]
  delegated_type :promotionable, dependent: :destroy, types: TYPES
  accepts_nested_attributes_for :promotionable

  delegate :to_s, to: :promotionable
  delegate_missing_to :promotionable

  default_scope { includes(:products_promotions) }

  # If products is empty, then the promotion applies to all of the seller's products
  has_and_belongs_to_many :products
  belongs_to :seller, class_name: "User"

  validates :name, length: {maximum: 50}, allow_blank: true
  validates :starts_on, :ends_on, presence: true
  validates :ends_on, comparison: {greater_than: :starts_on}
  # Minimum number of items required to qualify for the promotion
  validates :min_quantity, numericality: {only_integer: true}
  # Maximum number of items that can be discounted by the promotion. If non-positive,
  # there is no limit.
  validates :max_quantity, numericality: {only_integer: true}
  validates :max_quantity,
    comparison: {greater_than_or_equal_to: :min_quantity},
    unless: -> { max_quantity <= 0 }

  scope :active, -> { where("starts_on <= ? AND ends_on >= ?", Time.now, Time.now) }

  def started?
    starts_on < Time.now
  end

  def ended?
    ends_on < Time.now
  end

  def active?
    started? && !ended?
  end
end
