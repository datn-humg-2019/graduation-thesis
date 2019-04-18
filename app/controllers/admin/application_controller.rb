class Admin::ApplicationController < ActionController::Base
  layout "dashboard"

  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :check_admin

  private
  def convert_date date
    Date.strptime(date, t("date")).strftime("%Y/%m/%d") if date.present?
  rescue ArgumentError
    date
  end

  def convert_date_to_local date
    date&.strftime(t("date")) if date
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_admin
    redirect_to root_path if user_signed_in? && !current_user.admin?
  end

  def repond_js
    respond_to do |format|
      format.html
      format.js
    end
  end
end
