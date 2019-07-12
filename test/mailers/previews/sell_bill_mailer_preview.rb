# Preview all emails at http://localhost:3000/rails/mailers/sell_bill_mailer
class SellBillMailerPreview < ActionMailer::Preview
  def sell_bill_preview
    SellBillMailer.sell_bill Sell.last, "tuanbacyen@gmail.com"
  end
end
