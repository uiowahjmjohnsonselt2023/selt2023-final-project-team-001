class PriceAlertsController < ApplicationController
  def send_price_alert
    email_address = "your_email@example.com" # Replace with the recipient's email
    PriceAlertMailer.price_alert_email(email_address).deliver_now
    render plain: "Price alert email sent!" # Remove later, just for debugging
  end

  def send_test_email
    email_address = "your_email@example.com" # Replace with the recipient's email
    PriceAlertMailer.test_email(email_address).deliver_now
    render plain: "Test email sent!" # Remove later, just for debugging
  end
end
