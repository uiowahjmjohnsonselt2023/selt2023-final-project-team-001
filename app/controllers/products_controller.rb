class ProductsController < ApplicationController
  before_action :require_login, except: [:show, :index]
  before_action :require_seller, only: [:new, :create]

  def index
    @products = Product.includes(:categories).only_public.in_stock
    @products = @products.search_text(params[:search]) if params[:search]
    sort = params[:sort]
    unless %w[asc desc].include?(params[:order].to_s)
      redirect_to products_path(sort: params[:sort], search: params[:search], cat: params[:cat], order: "desc") and return
    end
    if sort
      # This is needed to clear the sort order imposed
      # by search_text (which orders by search rank).
      @products.order_values = []
      @products = case sort
      when "price"
        @products.order(price_cents: params[:order].to_sym)
      when "name"
        @products.order(name: params[:order].to_sym)
      when "date"
        @products.order(created_at: params[:order].to_sym)
      when "views"
        @products.order(views: params[:order].to_sym)
      else
        @products
      end
    end
    cat = params[:category]
    if cat
      if Category.where(id: cat).blank?
        flash[:alert] = "#{cat} isn't a valid category."
        redirect_to products_path(sort: params[:sort]) and return
      end
      case sort
      when "price"
        Product.joins(:categories).where(categories: cat).where.not(quantity: 0).where(private: false).order(:price_cents)
      when "name"
        Product.joins(:categories).where(categories: cat).where.not(quantity: 0).where(private: false).order(:name)
      when "date"
        Product.joins(:categories).where(categories: cat).where.not(quantity: 0).where(private: false).order(created_at: :desc)
      when "views"
        Product.joins(:categories).where(categories: cat).where.not(quantity: 0).where(private: false).order(views: :asc)
      else
        Product.joins(:categories).where(categories: cat).where.not(quantity: 0).where(private: false).order(created_at: :desc)
      end
      @products = @products.joins(:categories).where(categories: {id: cat})
    end
    @products = @products.search_text(params[:search]) if params[:search]
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
    unless Current.user.nil?
      unless @product.viewed_by_users.include? Current.user
        @product.viewed_by_users << Current.user
        @product.update(views: @product.views + 1)
      end
    end
  end

  def new
    @product = Product.new
  end

  def create
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
      render "edit", status: :unprocessable_entity
    end
  end

  def history
    if Current.user.nil?
      flash[:alert] = "Please log in to view your shopping history."
      redirect_to login_path
    else
      @user = Current.user
      ids = []
      @user.viewed_products.each do |vp|
        ids.append(vp.product_id)
      end
      @products = Product.where(id: ids)
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
