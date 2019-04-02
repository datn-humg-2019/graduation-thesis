class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
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
