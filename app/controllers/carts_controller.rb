class CartsController < ApplicationController
  before_action :require_login

  def add_to_cart
    # Add to cart
    cart = Cart.new(product_id: params[:product_id], quantity: params[:quantity])
    cart.user = Current.user
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
