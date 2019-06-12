# https://mangxuyenviet.vn/article/Gmail-cho-phep-ung-dung-kem-an-toan-581.html
class SellBillMailer < ApplicationMailer
  default from: "kotviet.vn@gmail.com"

  def sell_bill sell, email
    @sell = sell

    mail to: email, subject: "Hóa đơn bán hàng"
  end
end
