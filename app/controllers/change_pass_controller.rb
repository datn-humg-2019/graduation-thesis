class ChangePassController < ApplicationController
  before_action :check_change_login!

  def index; end

  def update
    user = User.find_by email: params[:email]
    otp = params[:otp]
    new_pass = params[:new_pass]
    unless user.nil?
      otps = user.check_otp otp
      unless otps.blank?
        user.update_attributes(password: new_pass, password_confirmation: new_pass)
        otps.destroy_all
        redirect_to root_path
      end
    end
  end

  private
  def check_change_login!
    redirect_to root_path unless current_user.nil?
  end
end
