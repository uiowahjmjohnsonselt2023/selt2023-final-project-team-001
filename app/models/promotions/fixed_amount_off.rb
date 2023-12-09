class Promotions::FixedAmountOff < ApplicationRecord
  include Promotionable

  monetize :amount_cents, numericality: {greater_than: 0}

  def apply(order)
    [order.subtotal - amount, 0].max if eligible?(order)
  end
end
