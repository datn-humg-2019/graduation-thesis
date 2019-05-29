class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_request!
  before_action :load_user_authentication, only: :create

  def create; end

  private

  def load_user_authentication
    user = User.find_by("email = ? OR phone = ?", params[:email], params[:username])
    if user&.valid_password?(params[:password])
      render_json user.load_token_user, "Đăng nhập thành công"
    else
      render_json nil, "Đăng nhập thất bại", 1
    end
  end
end
