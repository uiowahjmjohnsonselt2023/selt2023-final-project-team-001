class ProductsController < ApplicationController
  before_action :require_login, except: [:show, :index]

  def index
    @products = Product.all
    @products = Product.only_public.in_stock
    @products = @products.search_text(params[:search]) if params[:search].present?
    sort = params[:sort]
    if sort
      # This is needed to clear the sort order imposed
      # by search_text (which orders by search rank).
      @products.order_values = []
      @products = case sort
      when "price"
        @products.order(:price_cents)
      when "name"
        @products.order(:name)
      when "date"
        @products.order(created_at: :desc)
      else
        @products
      end
    end
  end

  def show
    # Raises ActiveRecord::RecordNotFound if not
    # found, which will render the 404 page.
    @product = Product.find params[:id]
    @seller = @product.seller
    if @product.private
      unless Current.user == @seller || Current.user&.is_admin
        flash[:alert] = "You don't have permission to view that product."
        redirect_to root_path
      end
    end
  end

  def new
    unless Current.user.is_seller
      flash[:alert] = "You must be a seller to create a product."
      redirect_to root_path and return
    end
    @product = Product.new
  end

  def create
    unless Current.user.is_seller
      flash[:alert] = "You must be a seller to create a product."
      redirect_to root_path and return
    end
    @product = Product.new(product_params)
    @product.seller = Current.user
    if @product.save
      redirect_to @product
    else
      flash[:alert] = "Please fix the errors below."
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find params[:id]
    if Current.user != @product.seller && !Current.user.is_admin
      flash[:alert] = "You don't have permission to edit that product."
      redirect_to root_path
    end
  end

  def update
    @product = Product.find params[:id]
    if Current.user != @product.seller && !Current.user.is_admin
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
      :name,
      :description,
      :price,
      :quantity,
      :condition,
      :private,
      {photos: []},
      category_ids: []
    )
  end
end
