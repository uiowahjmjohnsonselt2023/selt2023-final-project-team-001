class CheckoutsController < ApplicationController
  before_action :require_login
  before_action :index, except: [:index]

  def index
    cart = Cart.where(user_id: session[:user_id])

    @products_in_cart = []
    @product_ids_and_quantity = []
    @cart_price = 0
    @empty = "Your cart is empty!"

    if cart.present?
      cart.each do |product|
        p = Product.find_by(id: product.product_id)
        total_price = p.price * product.quantity
        @cart_price += total_price
        @products_in_cart.push({
          name: p.name,
          total_price: total_price,
          original_quantity: p.quantity,
          quantity: product.quantity,
          id: product.product_id
        })
        @product_ids_and_quantity.push({id: product.product_id, quantity: product.quantity})
      end
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
      render :index, status: :unprocessable_entity
    else
      @product_ids_and_quantity.each do |p|
        Cart.find_by(user_id: session[:user_id], product_id: p[:id]).destroy
        product = Product.find_by(id: p[:id])
        product.update!(quantity: (product.quantity - Integer(p[:quantity])))
        @transaction = Transaction.new(buyer_id: session[:user_id], seller_id: product.seller_id, product_id: product.id, price_cents: product.price_cents, quantity: p[:quantity])
        @transaction.save
      end
      flash[:notice] = "Order placed successfully!"
      redirect_to checkout_path
    end
  end
end
