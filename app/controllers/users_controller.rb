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

  def purchase_history
    if session[:user_id].nil?
      flash[:alert] = "You must log in to view your purchase history"
      redirect_to login_path
    else
      @user = Current.user
      @others = []
      @transactions = Transaction.where(buyer_id: @user.id).order(created_at: :desc)
      @transactions.each do |t|
        sid = t.seller_id
        @seller = User.where(id: sid).first
        @product = Product.where(id: t.product_id).first
        if @seller.storefront.nil?
          @others.append({seller: @seller.first_name + " " + @seller.last_name, storefront: @seller.storefront, profile: @seller.profile, product: @product.name, quantity: t.quantity, price_cents: t.price_cents.to_f / 100.0, created_at: t.created_at, product_id: @product.id})
        else
          sf = Storefront.where(user_id: @seller.id).first
          @others.append({seller: sf.name, storefront: @seller.storefront, profile: @seller.profile, product: @product.name, quantity: t.quantity, price_cents: t.price_cents.to_f / 100.0, created_at: t.created_at, product_id: @product.id})
        end
      end
    end
  end

  def sales_history
    if session[:user_id].nil?
      flash[:alert] = "You must log in to view your sales history"
    elsif Current.user.is_seller
      @user = Current.user
      @others = []
      @transactions = Transaction.where(seller_id: @user.id).order(created_at: :desc)
      @transactions.each do |t|
        bid = t.buyer_id
        @buyer = User.where(id: bid).first
        @product = Product.where(id: t.product_id).first
        @others.append({buyer: @buyer.first_name + " " + @buyer.last_name, product: @product.name, quantity: t.quantity, profile: @buyer.profile, price_cents: t.price_cents.to_f / 100.0, created_at: t.created_at, product_id: @product.id})
      end
    else
      flash[:alert] = "You must register as a seller to view sales history"
      redirect_to root_path
    end
  end

  def register
  end

  def new_seller
    Current.user.update_attribute(:is_seller, true)
    Current.user.update_attribute(:storefront_requested, 0)
    flash[:notice] = "Registration successful"
    redirect_to root_path
  end
end
