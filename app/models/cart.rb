class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def subtotal
    cart_items.sum(&:subtotal)
  end
end
