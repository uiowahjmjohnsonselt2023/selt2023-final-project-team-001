class PriceAlert < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :product_id, uniqueness: {scope: :user_id, message: "You already have a price alert for this product."}
  validates :threshold, numericality: {greater_than: 0, message: "Threshold must be greater than 0."}
end
