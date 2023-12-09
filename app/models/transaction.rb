class Transaction < ApplicationRecord
  has_many :transactions_products, dependent: :destroy
  has_many :products, through: :transactions_products
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id"
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"

  # You can add any additional validations or methods here
end
