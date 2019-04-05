class Admin::ApplicationController < ActionController::Base
  layout "dashboard"

  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :check_admin

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def check_admin
    redirect_to root_path unless current_user.admin?
  end

  def repond_js
    respond_to do |format|
      format.html
      format.js
    end
  end
end
