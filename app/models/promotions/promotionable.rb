module Promotionable
  extend ActiveSupport::Concern

  included do
    has_one :promotion, as: :promotionable, touch: true
    delegate_missing_to :promotion
  end

  def product_eligible?(cart_item)
    if products.empty?
      cart_item.seller == seller
    else
      products.include?(cart_item.product)
    end
  end

  # Returns whether the given cart item is eligible for this promotion. This
  # doesn't include checking whether the item meet's the promotion's minimum
  # quantity requirement, since that depends on the cart as a whole (since the
  # min_quantity can be met by mixing and matching products).
  def eligible?(cart_item)
    active? && cart_item.applied_promotion.nil? && product_eligible?(cart_item)
  end
end
