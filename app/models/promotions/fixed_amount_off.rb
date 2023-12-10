class Promotions::FixedAmountOff < ApplicationRecord
  include Promotions::Promotionable

  monetize :amount_cents, numericality: {greater_than: 0}

  def discount(cart_items)
    if max_quantity > 0
      # This is necessary since some items may be priced below the discount amount, so
      # we need to apply the promotion to higher priced items first.
      cart_items = cart_items.sort_by { |ci| -ci.price } # descending order
      cart_items = below_max_quantity(cart_items)
    end
    cart_items.each do |ci|
      ci.applied_promotion = self
      ci.discounted_subtotal = [ci.subtotal - amount * ci.quantity, 0].max
    end
  end

  def to_s
    name || "#{amount.format} off select items"
  end
end
