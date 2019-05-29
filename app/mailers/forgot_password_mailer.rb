# https://mangxuyenviet.vn/article/Gmail-cho-phep-ung-dung-kem-an-toan-581.html
class ForgotPasswordMailer < ApplicationMailer
  default from: "tuanpahumg@gmail.com"

  def forgot_email user
    char = [("a".."z"), ("A".."Z"), (0..9)].map(&:to_a).flatten
    @otp = (0...10).map{char[rand(char.length)]}.join
    @user = user
    @user.otps.where(otp_type: 0).create otp: @otp

    mail to: @user.email, subject: "Yêu cầu đổi mật khẩu"
  end
end
