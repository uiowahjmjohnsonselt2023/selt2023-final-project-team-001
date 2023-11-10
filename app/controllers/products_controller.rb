class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    @product.categorizations.build
  end

  def create
    @product = Product.new(product_params)
    @product.seller = User.first
    if @product.save
      redirect_to @product
    else
      flash[:alert] = "Please fix the errors below."
      render "new"
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
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
