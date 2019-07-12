# https://mangxuyenviet.vn/article/Gmail-cho-phep-ung-dung-kem-an-toan-581.html
class SellBillMailer < ApplicationMailer
  default from: "kotviet.vn@gmail.com"

  def sell_bill sell, email
    @sell = sell
    @list_items = @sell.details.hash_product_details
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/kotviet.png"))
    mail to: email, subject: "Hóa đơn bán hàng"
  end
end
