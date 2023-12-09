class CheckoutsController < ApplicationController
  before_action :require_login
  before_action :index, except: [:index]

  def index
    cart = Cart.find_or_create_by(user: Current.user)
    cart_items = cart.apply_promotions

    @applied_promotions = cart_items.lazy
      .reject { |ci| ci.applied_promotion.nil? }
      .map { |ci| [ci.applied_promotion, ci.discount] }
      .group_by(&:first)
      .transform_values { |v| v.sum(&:second) }

    @products_in_cart = cart_items.map do |cart_item|
      {
        name: cart_item.product.name,
        original_total_price: cart_item.subtotal,
        total_price: cart_item.discounted_subtotal,
        original_quantity: cart_item.product.quantity,
        quantity: cart_item.quantity,
        id: cart_item.product_id
      }
    end

    @product_ids_and_quantity = cart_items.map do |cart_item|
      {id: cart_item.product_id, quantity: cart_item.product.quantity}
    end

    @cart_original_price = cart.subtotal
    @cart_price = cart.discounted_subtotal
    @empty = "Your cart is empty!"
  end

  def update_quantity
    cart = CartItem.where(user_id: session[:user_id], product_id: params[:product_id])
    if params[:quantity] != cart.pluck(:quantity).first.to_s
      cart.update(quantity: params[:quantity])
      flash[:success] = "Item quantity updated successfully!"
      redirect_to checkout_path
    end
  end

  def remove_from_cart
    if params[:confirmation] == "yes"
      CartItem.find_by(user_id: session[:user_id], product_id: params[:product_id]).destroy
      flash[:success] = "Item removed from cart."
    end
    redirect_to checkout_path
  end

  def update_product_inventory
    if @products_in_cart.empty?
      flash[:alert] = "You must add products to your cart to purchase them!"
      render :index
    else
      @product_ids_and_quantity.each do |p|
        CartItem.find_by(user_id: session[:user_id], product_id: p[:id]).destroy
        product = Product.find_by(id: p[:id])
        product.update!(quantity: (product.quantity - Integer(p[:quantity])))
      end
      flash[:notice] = "Order placed successfully!"
      redirect_to checkout_path
    end
  end
end
