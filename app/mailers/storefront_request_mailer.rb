class StorefrontRequestMailer < ApplicationMailer
  def request_approval
    @email = params[:user].email

    mail(to: @email, subject: "New storefront request", body: "A user on Shoppr has requested to open a storefront. You can review their request here: TODO ADD LINK")
  end
end
