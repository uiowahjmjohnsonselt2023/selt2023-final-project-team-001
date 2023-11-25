class CartsController < ApplicationController
  before_action :require_login

  def add_to_cart
    product = Product.find params[:product_id]
    cart = Cart.find_by(product: product, user: Current.user)
    if cart
      cart.quantity += params[:quantity].to_i
    else
      cart = Cart.new(
        product: product, user: Current.user, quantity: params[:quantity].to_i
      )
    end
    cart.quantity = [cart.quantity, product.quantity].min
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
