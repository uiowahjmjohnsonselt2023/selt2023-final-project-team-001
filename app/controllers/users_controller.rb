class UsersController < ApplicationController
  before_action :require_login, only: [:register, :new_seller]
  before_action :require_not_seller, only: [:register, :new_seller]

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def index
  end

  def show
    @user = Current.user
    unless Current.user?(params[:id])
      flash[:warning] = "Can only show profile of logged-in user"
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Sign up successful!"
      redirect_to login_path
    else
      flash[:alert] = "Invalid input(s)!"
      render "new", status: :unprocessable_entity
    end
  end

  def transaction_history
    t_hist = params[:trans_hist]
    unless session[:user_id].nil?
      @user = Current.user
      @others = []
      case t_hist
      when "seller"
        @transactions = Transaction.where(seller_id: @user.id)
        @transactions.each do |t|
          @buyer = User.where(id: t.buyer_id)
          @others.append({buyer: @buyer.first_name + " " + @buyer.last_name, product: t.product_id, price: t.price_cents})
        end
      when "buyer"
        @transactions = Transaction.where(seller_id: @user.id)
        @transactions.each do |t|
          @seller = User.where(id: t.seller_id)
          @product = Product.where(id: t.product_id)
          @others.append({seller: @seller.first_name + " " + @seller.last_name, product: @product.name, price: t.price_cents})
        end
      else
        flash[:warning] = "You must log in to view your transaction history"
        redirect_to login_path
      end
      @others = User.where(id: @other_ids)
    end
  end

  def register
  end

  def new_seller
    Current.user.update_attribute(:is_seller, true)
    flash[:notice] = "Registration successful"
    redirect_to root_path
  end
end
