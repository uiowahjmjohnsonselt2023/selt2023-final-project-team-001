class Promotions::PercentOff < ApplicationRecord
  include Promotions::Promotionable

  before_validation :decimalize_percentage, if: -> { percentage > 1 }

  validates :percentage, numericality: {greater_than: 0, less_than_or_equal_to: 1}

  # @param [Array<CartItem>] cart_items
  def discount(cart_items)
    if max_quantity > 0
      # If there is a maximum number of items that can be discounted by the promotion,
      # then we need to apply the promotion to the items in the cart with the highest
      # price first.
      cart_items = cart_items.sort_by { |ci| -ci.price } # descending order
      cart_items = below_max_quantity(cart_items)
    end
    cart_items.each do |ci|
      ci.applied_promotion = self
      ci.discounted_subtotal = ci.subtotal * percentage
    end
  end

  def to_s
    name || "#{percentage * 100}% off select items"
  end

  private

  def decimalize_percentage
    self.percentage = percentage / 100
  end
end
