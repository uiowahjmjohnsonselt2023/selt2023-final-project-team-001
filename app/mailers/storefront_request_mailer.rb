class StorefrontRequestMailer < ApplicationMailer
  def request_approval
    @email = params[:admin]

    mail(to: @email, subject: "New storefront request", body: "A user on Shoppr has requested to open a storefront. You can review their request here: TODO ADD LINK")
  end

  def send_update
  end
end
