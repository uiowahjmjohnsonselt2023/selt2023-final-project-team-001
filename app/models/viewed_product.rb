# app/models/viewed_product.rb
class ViewedProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
