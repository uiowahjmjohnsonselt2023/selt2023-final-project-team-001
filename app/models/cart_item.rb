class CartItem < ApplicationRecord
  belongs_to :cart
  has_one :user, through: :cart
  belongs_to :product
  has_one :seller, through: :product
  has_many :promotions, through: :product

  delegate :price, to: :product # for convenience

  # Always eager load product since we almost always need it.
  # This way, we avoid n+1 queries.
  default_scope { includes(:product) }

  validates :quantity, numericality: {greater_than: 0, only_integer: true}

  def subtotal
    quantity * price
  end
end
