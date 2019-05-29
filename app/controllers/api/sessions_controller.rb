class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_request!
  before_action :load_user_authentication, only: :create

  def create; end

  private

  def load_user_authentication
    user = User.find_by("email = ? OR phone = ?", params[:email], params[:username])
    if user&.valid_password?(params[:password])
      render_json "Đăng nhập thành công", user.load_token_user
    else
      render_json "Đăng nhập thất bại", nil, 1
    end
  end
end
