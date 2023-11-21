class CheckoutsController < ApplicationController
  before_action :set_current_user, except: [:index]

  def index
    cart = Cart.where(user_id: session[:user_id])

    @products_in_cart = []
    @empty = "Your cart is empty!"

    if cart.present?
      cart.each do |product|
        p = Product.find_by(id: product.product_id)
        @current_quantity_of_product = p.quantity
        @products_in_cart.push({name: p.name, price: p.price_cents, quantity: product.quantity, id: product.product_id})
      end
    end
  end

  def update_quantity
    cart = Cart.where(user_id: session[:user_id], product_id: params[:product_id])
    cart.update(quantity: params[:quantity])
    redirect_to checkout_path
  end

  def remove_from_cart
    if params[:confirmation] == "yes"
      Cart.find_by(user_id: session[:user_id], product_id: params[:product_id]).destroy
      flash[:success] = "Item removed from cart."
    end
    redirect_to checkout_path
  end
end
