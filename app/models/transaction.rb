class Transaction < ApplicationRecord
  belongs_to :user, class_name: "Buyer"
  belongs_to :user, class_name: "Seller"
  belongs_to :product
end
