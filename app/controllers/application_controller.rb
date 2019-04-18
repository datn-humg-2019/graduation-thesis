class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def convert_date date
    Date.strptime(date, t("date")).strftime("%Y/%m/%d") if date.present?
  rescue ArgumentError
    date
  end

  def check_admin
    redirect_to admin_path if user_signed_in? && current_user.admin?
  end

  def convert_date_to_local date
    date&.strftime(t("date")) if date
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def repond_js
    respond_to do |format|
      format.html
      format.js
    end
  end

  # def user_confirmed
  #   return if current_user.nil?
  #   render "pages/404" unless current_user.confirmed
  # end

  protected

  def configure_permitted_parameters
    added_attrs = [:phone, :email, :password, :remember_me]
  end
end
