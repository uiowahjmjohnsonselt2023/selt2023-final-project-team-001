class Promotion < ApplicationRecord
  delegated_type :promotionable, dependent: :destroy, types: %w[
    Promotion::PercentOff
    Promotion::FixedAmountOff
  ]

  # If products is empty, then the promotion applies to all of the seller's products
  has_and_belongs_to_many :products
  belongs_to :seller, class_name: "User"

  validates :name, length: {maximum: 50}, allow_blank: true
  validates :starts_on, :ends_on, presence: true
  validates :min_quantity, numericality: {only_integer: true}
  validates :max_quantity, numericality: {only_integer: true}
  validates :max_quantity,
    comparison: {greater_than: :min_quantity},
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
