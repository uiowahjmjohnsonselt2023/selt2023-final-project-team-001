class StorefrontRequestMailer < ApplicationMailer
  def request_approval
    @email = "shopprwebsite@gmail.com"

    mail(to: @email, subject: "New storefront request", body: "A user on Shoppr has requested to open a storefront. You can review their request here: #{show_requests_url}")
  end

  def request_approved
    @email = params[:email]
    mail to: @email
  end

  def request_denied
    @email = params[:email]
    mail to: @email
  end
end
