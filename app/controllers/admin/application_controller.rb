class Admin::ApplicationController < ActionController::Base
  layout "dashboard"

  protect_from_forgery with: :exception
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
