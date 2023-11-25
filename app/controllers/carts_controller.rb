class CartsController < ApplicationController
  before_action :require_login

  def add_to_cart
    product = Product.find params[:product_id]
    cart = Cart.find_or_initialize_by(
      product_id: product.id, user: Current.user
    )
    cart.quantity ||= 0
    cart.quantity += params[:quantity].to_i
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
