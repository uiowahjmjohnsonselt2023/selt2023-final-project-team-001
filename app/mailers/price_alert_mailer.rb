class PriceAlertMailer < ApplicationMailer
  def send_price_alert(email, product_name, current_price, threshold_price, old_price)
    mail(to: email, subject: "Price Alert for #{product_name}", body: "Current Price: #{current_price}\nOld Price: #{old_price}\nThreshold Price: #{threshold_price}")
  end
end
