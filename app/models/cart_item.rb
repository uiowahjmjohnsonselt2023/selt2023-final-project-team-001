class CartItem < ApplicationRecord
  belongs_to :cart
  has_one :user, through: :cart
  belongs_to :product
  has_one :seller, through: :product
  # Get the promotions from seller because product.promotions will only get promotions
  # specific to the product (i.e., it doesn't include promotions that apply to all
  # products from the same seller).
  has_many :promotions, through: :seller

  delegate :price, to: :product # for convenience

  # Always eager load product since we almost always need it.
  # This way, we avoid n+1 queries.
  default_scope { includes(:product) }

  validates :quantity, numericality: {greater_than: 0, only_integer: true}

  attr_accessor :applied_promotion
  # Annoyingly, monetize requires a column to be present, so we can't use it here.
  # monetize :discounted_subtotal_cents

  def subtotal
    quantity * price
  end

  def discounted_subtotal
    Money.new(@discounted_subtotal_cents || subtotal.cents)
  end

  def discount
    subtotal - discounted_subtotal
  end

  def discounted_subtotal=(money)
    # Ue try(:cents) to get the cents value if money is a Money object,
    # or just use money if it's an integer.
    @discounted_subtotal_cents = money.try(:cents) || money
  end
end
