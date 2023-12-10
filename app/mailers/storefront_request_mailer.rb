class StorefrontRequestMailer < ApplicationMailer
  def request_approval
    @email = "shopprwebsite@gmail.com"

    mail(to: @email, subject: "New storefront request", body: "A user on Shoppr has requested to open a storefront. You can review their request here: #{show_requests_url}")
  end

  def approve
    @email = params[:email]
    mail to: @email
  end

  def reject
    @email = params[:email]
    mail to: @email
  end
end
