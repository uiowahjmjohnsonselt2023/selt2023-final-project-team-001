class PriceAlertMailer < ApplicationMailer
  def send_price_alert(email, product_name, current_price, threshold_price)
    @product_name = product_name
    @current_price = current_price
    @threshold_price = threshold_price

    mail(to: email, subject: "Price Alert for #{@product_name}")
  end

  def test_email(email)
    mail(to: email, subject: "Test Email", body: "This is a test email.")
  end
end
