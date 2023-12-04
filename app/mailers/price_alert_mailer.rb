class PriceAlertMailer < ApplicationMailer
  def send_price_alert(email, product_id, threshold_price, old_price)
    @product = Product.find(product_id)
    product_name = @product.name
    current_price = @product.price
    mail(to: email, subject: "Price Alert for #{product_name}", body: "Current Price: $#{current_price}\nOld Price: $#{old_price}\nThreshold Price: $#{format("%.2f", threshold_price)}\nLink: #{url_for(controller: "products", action: "show", id: product_id, only_path: false)}")
  end
end
