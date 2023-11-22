class CheckoutsController < ApplicationController
  before_action :set_current_user, except: [:index]
  before_action :index, except: [:index]

  def index
    cart = Cart.where(user_id: session[:user_id])

    @products_in_cart = []
    @product_ids_and_quantity = []
    @empty = "Your cart is empty!"

    if cart.present?
      cart.each do |product|
        p = Product.find_by(id: product.product_id)
        @current_quantity_of_product = p.quantity
        @products_in_cart.push({name: p.name, price: p.price_cents, quantity: product.quantity, id: product.product_id})
        @product_ids_and_quantity.push({id: product.product_id, quantity: product.quantity})
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

  def update_product_inventory
    if @products_in_cart.empty?
      flash[:alert] = "You must add products to your cart to purchase them!"
      render :index
    else
      @product_ids_and_quantity.each do |p|
        # remove from cart and inventory
        Cart.find_by(user_id: session[:user_id], product_id: p[:id]).destroy
        product = Product.find_by(id: p[:id])
        product.update(quantity: (product.quantity - Integer(p[:quantity])))
      end
      flash[:notice] = "Order placed successfully!"
      redirect_to checkout_path
    end
  end
end
