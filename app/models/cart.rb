class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  has_many :promotions, through: :cart_items

  delegate :empty?, :size, :length, to: :cart_items

  def subtotal
    cart_items.sum(&:subtotal)
  end

  def discounted_subtotal
    cart_items.sum(&:discounted_subtotal)
  end

  def apply_promotions
    unless empty?
      promotions.each { |promo| promo.apply(self) }
    end
    cart_items # return cart_items for chaining
  end
end
