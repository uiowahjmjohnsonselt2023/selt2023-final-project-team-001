class CartItem < ApplicationRecord
  belongs_to :product
  has_one :seller, through: :product
  has_many :promotions, through: :product

  validates :quantity, numericality: {greater_than: 0, only_integer: true}
end
