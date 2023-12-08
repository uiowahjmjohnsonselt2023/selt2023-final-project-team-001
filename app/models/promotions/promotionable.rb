module Promotionable
  extend ActiveSupport::Concern

  included do
    has_one :promotion, as: :promotionable, touch: true
    delegate_missing_to :promotion
  end

  def product_eligible?(cart)
    if products.empty?
      cart.product.seller == seller
    else
      products.include?(cart.product)
    end
  end

  def eligible?(cart)
    active? && product_eligible?(cart)
  end
end
