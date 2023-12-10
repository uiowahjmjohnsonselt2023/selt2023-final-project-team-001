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
    # Can't just use a sum here because cart_items gets reloaded
    @discounted_subtotal || subtotal
  end

  def apply_promotions
    if !empty?
      # We have to do it like this so that the attributes that are set in the
      # promotions are maintained. If we just returned cart_items, they'd be
      # reloaded from the database and the attributes would be lost.
      items = cart_items.includes(:seller, seller: :promotions).to_a
      promotions.each { |promo| promo.apply(items) }
      @discounted_subtotal = items.sum(&:discounted_subtotal)
      items
    else
      cart_items
    end
  end
end
