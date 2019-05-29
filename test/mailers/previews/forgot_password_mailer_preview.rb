# Preview all emails at http://localhost:3000/rails/mailers/forgot_password_mailer
class ForgotPasswordMailerPreview < ActionMailer::Preview
  def forgot_password_preview
    ForgotPasswordMailer.forgot_email "tuanbacyen@gmail.com"
  end
end
