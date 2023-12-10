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
    if Current.user.nil?
      redirect_to login_path and return
    end
    case Current.user.storefront_requested
    when 0
      # add request here
    when 100
      flash[:notice] = "Your storefront request is currently pending approval. \nYou will receive a notification when the status of your request has changed."
    when 200
      flash[:notice] = "It looks like you have had a previous storefront request rejected. \nIn order to request a new storefront, you will need to appeal this rejection."
    when 300
      flash[:notice] = "It looks like you are currently appealing to open a new storefront. \nYou will be notified when there are changes to the status of your appeal."
    when 400
      if Current.user.storefront
        flash[:alert] = t("storefronts.create.already_exists")
        redirect_to storefront_path(Current.user.storefront)
      else
        redirect_to new_storefront_path
      end
    else
      redirect_to root_path
    end
  end

  def process_request
    if Current.user.nil?
      redirect_to login_path and return
    end
    @user = Current.user
    unless @user.profile.seller_rating.nil?
      if @user.profile.seller_rating < 3
        flash[:warning] = "Your seller rating is too low to set up a storefront at this time. Sellers must have a rating of at least 3 stars to set up a store front."
        redirect_to root_path and return
      elsif Review.where(seller_id: @user.id).count < 5
        flash[:warning] = "You do not have enough reviews to set up a storefront. You must have at least 5 reviews."
        redirect_to root_path and return
      else
        if @user.storefront_requested == 100
          flash[:notice] = "It looks like you already have a pending storefront request. We will contact you when the request has been reviewed."
          redirect_to redirect_to profile_path(@user) and return
        end
        @user.update_attribute!(:storefront_requested, 100)
        StorefrontRequestMailer.request_approval.deliver_now
        redirect_to profile_path(@user.profile) and return
      end
    end
    flash[:alert] = "You do not have any reviews yet."
    redirect_to root_path
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

  def process_admin_review
    unless Current.user.nil?
      unless Current.user.is_admin?
        flash[:alert] = "You don't have permission to view that page."
        redirect_to root_path and return
      end
      @user = User.where(id: params[:user]).first
      if params[:approve]
        @user.update_attribute!(:storefront_requested, 400)
        StorefrontRequestMailer.approve.with(email: @user.email).deliver_now
        flash[:notice] = "User request approved"
      else
        @user.update_attribute!(:storefront_requested, 200)
        StorefrontRequestMailer.reject.with(email: @user.email).deliver_now
        flash[:alert] = "User request rejected"
      end
      redirect_to profile_path(@user.profile) and return
    end
    flash[:alert] = "Please log in"
    redirect_to login_path
  end

  private

  def storefront_params
    params.require(:storefront).permit(:name, :short_description, :custom_code)
  end
end
