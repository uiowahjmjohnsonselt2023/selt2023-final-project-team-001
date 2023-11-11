class ProductsController < ApplicationController
  before_action :set_current_user, except: [:show, :index]

  def index
  end

  def show
    @product = Product.find(params[:id])
    if @product.private
      # can't use set_current_user because it redirects
      current_user = User.find_by(id: session[:user_id])
      unless current_user == @product.seller || current_user&.is_admin
        flash[:alert] = "You don't have permission to view that product."
        redirect_to root_path
      end
    end
  end

  def new
    unless current_user.is_seller || current_user.is_admin
      flash[:alert] = "You must be a seller to create a product."
      redirect_to root_path and return
    end
    @product = Product.new
    @product.categorizations.build
  end

  def create
    unless current_user.is_seller || current_user.is_admin
      flash[:alert] = "You must be a seller to create a product."
      redirect_to root_path and return
    end
    @product = Product.new(product_params)
    @product.seller = current_user
    if @product.save
      redirect_to @product
    else
      flash[:alert] = "Please fix the errors below."
      render "new"
    end
  end

  def edit
    @product = Product.find(params[:id])
    unless current_user == @product.seller || current_user.is_admin
      flash[:alert] = "You don't have permission to edit that product."
      redirect_to root_path
    end
  end

  def update
    @product = Product.find(params[:id])
    if current_user != @product.seller && !current_user.is_admin
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
