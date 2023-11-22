class ProductsController < ApplicationController
  before_action :require_login, except: [:show, :index]

  def index
    sort = params[:sort]
    @products = case sort
    when "price"
      Product.where.not(quantity: 0).where(private: false).order(:price_cents)
    when "name"
      Product.where.not(quantity: 0).where(private: false).order(:name)
    when "date"
      Product.where.not(quantity: 0).where(private: false).order(created_at: :desc)
    else
      Product.where.not(quantity: 0).where(private: false).order(created_at: :desc)
    end
  end

  def show
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:alert] = "That product doesn't exist."
      redirect_to root_path
    elsif @product.private
      unless Current.user == @product.seller || Current.user&.is_admin
        flash[:alert] = "You don't have permission to view that product."
        redirect_to root_path
      end
    end
  end

  def new
    unless Current.user.is_seller || Current.user.is_admin
      flash[:alert] = "You must be a seller to create a product."
      redirect_to root_path and return
    end
    @product = Product.new
    @product.categorizations.build
  end

  def create
    unless Current.user.is_seller || Current.user.is_admin
      flash[:alert] = "You must be a seller to create a product."
      redirect_to root_path and return
    end
    @product = Product.new(product_params)
    @product.seller = Current.user
    if @product.save
      redirect_to @product
    else
      flash[:alert] = "Please fix the errors below."
      render "new"
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:alert] = "That product doesn't exist."
      redirect_to root_path
    elsif Current.user != @product.seller && !Current.user.is_admin
      flash[:alert] = "You don't have permission to edit that product."
      redirect_to root_path
    end
  end

  def update
    @product = Product.find_by(id: params[:id])
    if @product.nil?
      flash[:alert] = "That product doesn't exist."
      redirect_to root_path
    elsif Current.user != @product.seller && !Current.user.is_admin
      flash[:alert] = "You don't have permission to edit that product."
      redirect_to root_path
    elsif @product.update(product_params)
      redirect_to @product
    else
      flash[:alert] = "Please fix the errors below."
      render "edit"
    end
  end

  private

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :quantity, :condition, :private
    )
  end
end
