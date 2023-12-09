class StorefrontsController < ApplicationController
  before_action :require_login, except: [:index, :show]
  before_action :require_seller, except: [:index, :show]

  def index
    @storefronts = Storefront.all
    @storefronts = @storefronts.search_text(params[:search]) if params[:search].present?
  end

  def new
    if Current.user.storefront
      flash[:alert] = t("storefronts.create.already_exists")
      redirect_to storefront_path(Current.user.storefront)
    else
      @storefront = Storefront.new({user: Current.user})
    end
  end

  def create
    if Current.user.storefront
      flash[:alert] = t("storefronts.create.already_exists")
      redirect_to storefront_path(Current.user.storefront)
    else
      @storefront = Current.user.create_storefront storefront_params
      if @storefront.save
        flash[:notice] = t("storefronts.create.success")
        redirect_to @storefront
      else
        flash[:alert] = t("storefronts.create.failure")
        render "new", status: :unprocessable_entity
      end
    end
  end

  def make_request
    case Current.user.storefront_requested
    when 0
      # add request here
    when 100
      flash[:notice] = "Your storefront request is currently pending approval. \n You will receive a notification when the status of your request has changed."
    when 200
      flash[:notice] = "It looks like you have had a previous storefront request rejected. In order to request a new storefront, you will need to appeal this rejection."
    when 300
      flash[:notice] = "It looks like you are currently appealing to open a new storefront. You will be notified when there are changes to the status of your appeal."
    else
      if Current.user.storefront
        flash[:alert] = t("storefronts.create.already_exists")
        redirect_to storefront_path(Current.user.storefront)
      end
    end
  end

  def edit
    @storefront = Storefront.find(params[:id])
    if Current.user != @storefront.user && !Current.user.is_admin
      flash[:alert] = t("storefronts.update.permission_denied")
      redirect_to root_path
    end
  end

  def update
    @storefront = Storefront.find(params[:id])
    if Current.user != @storefront.user && !Current.user.is_admin
      flash[:alert] = t("storefronts.update.permission_denied")
      redirect_to root_path
    elsif @storefront.update(storefront_params)
      flash[:notice] = t("storefronts.update.success")
      redirect_to @storefront
    else
      flash[:alert] = t("storefronts.update.failure")
      render "edit", status: :unprocessable_entity
    end
  end

  def choose_template
    @storefront = Storefront.find(params[:id])
    if Current.user != @storefront.user && !Current.user.is_admin
      flash[:alert] = t("storefronts.update.permission_denied")
      redirect_to root_path
    end
    flash[:notice] = t("storefronts.update.success")
  end

  def customize
    @storefront = Storefront.find(params[:id])
    if Current.user != @storefront.user && !Current.user.is_admin
      flash[:alert] = t("storefronts.update.permission_denied")
      redirect_to root_path
    else
      @products = Current.user.products.where(private: false)
    end
  end

  def show
    @storefront = Storefront.find(params[:id])
    @user = @storefront.user
    @products = @user.products.where(private: false)

    if @storefront.custom_code == "1"
      render :template1 and return
    elsif @storefront.custom_code == "2"
      render :template2 and return
    end
    @custom_code = @storefront&.custom_code || "" # Fetch custom code or default to empty string

    respond_to do |format|
      format.html do
        headers["Content-Type"] = "text/html"
        render :show
      end
    end
  end

  def preview
    @custom_code = storefront_params[:custom_code] || ""
  end

  private

  def storefront_params
    params.require(:storefront).permit(:name, :short_description, :custom_code)
  end
end
