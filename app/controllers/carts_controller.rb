class CartsController < ApplicationController
  before_action :require_login

  def add_to_cart
    product = Product.find params[:product_id]
    cart = Cart.find_by(user: Current.user)
    quantity = params[:quantity].to_i
    cart_item = if cart
      cart_item = cart.cart_items.find_by(product: product)
      if cart_item
        cart_item.quantity += quantity
        cart_item
      else
        cart.cart_items.build(product: product, quantity: quantity)
      end
    else
      cart = Cart.create!(user: Current.user)
      cart.cart_items.build(product: product, quantity: quantity)
    end
    # cart = Cart.find_or_create_by!(user: Current.user)
    # cart = CartItem.find_by(product: product, user: Current.user)
    # if cart
    #   cart.quantity += params[:quantity].to_i
    # else
    #   cart = CartItem.new(
    #     product: product, user: Current.user, quantity: params[:quantity].to_i
    #   )
    # end
    cart_item.quantity = [cart_item.quantity, product.quantity].min
    if cart.save
      flash[:notice] = "Item added to cart."
      redirect_to checkout_path
    else
      flash[:alert] = "Item could not be added to cart!"
      # rerender the page
      redirect_to product_path(params[:product_id])
    end
  end
end
