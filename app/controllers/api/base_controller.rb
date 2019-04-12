class Api::BaseController < ActionController::API
  require "jsonwebtoken"

  before_action :authenticate_request!
  before_action :set_locale
  helper_method :render_json

  def render_json data = nil, message = "", error = false, status = 200
    options = {
      status: status,
      error: error,
      message: message,
      data: data
    }

    render json: options, status: status
  end

  private

  def load_all_categories
    @categories = Category.root_category
  end

  attr_reader :current_user

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def authenticate_request!
    token = request.headers["Authorization"].split(" ").last rescue nil

    unless token
      render json: {status: 501, error: true,
        message: "Please log in",
        data: nil}, status: 501
      return
    end

    payload = JsonWebToken.decode token

    if payload.nil? || !JsonWebToken.valid_payload(payload.first)
      render json: {status: 402, error: true,
        message: "Please log in",
        data: nil}, status: 402
      return
    end

    @current_user = User.find_by id: payload.first["user_id"]
  end
end
