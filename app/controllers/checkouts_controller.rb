class CheckoutsController < ApplicationController
  before_action :require_login, except: [:index]
  before_action :index, except: [:index]

  def index
    if session[:user_id].present?
      cart = Cart.where(user_id: session[:user_id])

      @products_in_cart = []
      @product_ids_and_quantity = []
      @empty = "Your cart is empty!"

      if cart.present?
        cart.each do |product|
          p = Product.find_by(id: product.product_id)
          @products_in_cart.push({name: p.name, price: p.price_cents, original_quantity: p.quantity, quantity: product.quantity, id: product.product_id})
          @product_ids_and_quantity.push({id: product.product_id, quantity: product.quantity})
        end
      end
    else
      flash[:alert] = "Login to view your cart and make purchases!"
      redirect_to login_path
    end
  end

  def update_quantity
    cart = Cart.where(user_id: session[:user_id], product_id: params[:product_id])
    if params[:quantity] != cart.pluck(:quantity).first.to_s
      cart.update(quantity: params[:quantity])
      flash[:success] = "Item quantity updated successfully!"
      redirect_to checkout_path
    end
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
        # need to figure out how to handle the case where the quantity is 1
        # and the product is bought. By default the quantity has to be > 0, so
        # if we try to update it to 0 it will fail and rollback
        product.update!(quantity: (product.quantity - Integer(p[:quantity])))
      end
      flash[:notice] = "Order placed successfully!"
      redirect_to checkout_path
    end
  end
end
