module Promotions
  def self.table_name_prefix
    "promotions_"
  end

  module Promotionable
    extend ActiveSupport::Concern

    included do
      has_one :promotion, as: :promotionable, touch: true
      # delegate_missing_to :promotion
      delegate(
        :name,
        :starts_on, :ends_on,
        :min_quantity, :max_quantity,
        :products, :seller,
        :started?, :ended?, :active?,
        to: :promotion
      )
    end

    def product_eligible?(cart_item)
      if products.empty?
        cart_item.seller == seller
      else
        products.include?(cart_item.product)
      end
    end

    # @param [Array<CartItem>] cart_items
    # @return [Array<CartItem>] The first cart items whose total quantity
    #   is less than the maximum quantity allowed by the promotion. For simplicity,
    #   we don't try to find the best combination of cart items that maximizes the
    #   total quantity while staying below the maximum quantity.
    # @todo Account for individual products, e.g.,
    #   Product1 quantity 3 and Product2 quantity 2 with max_quantity 4
    #   -> Product1 quantity 3 and Product2 quantity 1, leaving 1 Product2
    def below_max_quantity(cart_items)
      if max_quantity <= 0 || cart_items.sum(&:quantity) <= max_quantity
        return cart_items
      end

      included_items = []
      total_quantity = 0
      cart_items.each do |item|
        break if total_quantity >= max_quantity
        if total_quantity + item.quantity <= max_quantity
          included_items << item
          total_quantity += item.quantity
        end
      end
      included_items
    end

    # Returns whether the given cart item is eligible for this promotion. This
    # doesn't include checking whether the item meet's the promotion's minimum
    # quantity requirement, since that depends on the cart as a whole (since the
    # min_quantity can be met by mixing and matching products).
    def eligible?(cart_item)
      active? && cart_item.applied_promotion.nil? && product_eligible?(cart_item)
    end

    # @param [Array<CartItem>] cart_items
    def apply(cart_items)
      cart_items = cart_items.filter { |ci| eligible?(ci) }
      discount(cart_items) if cart_items.sum(&:quantity) >= min_quantity
    end

    def to_s
      # Provide a default to_s in case the subclass doesn't define one.
      name || "Promotion"
    end
  end
end
