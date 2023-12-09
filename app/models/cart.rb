class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def subtotal
    cart_items.sum(&:subtotal)
  end

  def discounted_subtotal
    cart_items.sum(&:discounted_subtotal)
  end

  def apply_promotions
    promotions.each { |promo| promo.apply(self) }
  end
end
