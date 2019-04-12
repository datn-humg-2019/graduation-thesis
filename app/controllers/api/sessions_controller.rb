class Api::SessionsController < Api::BaseController
  skip_before_action :authenticate_request!
  before_action :load_user_authentication, only: :create

  def create; end

  private

  def load_user_authentication
    user = User.find_by("email = ? OR phone = ?", params[:username], params[:username])
    if user&.valid_password?(params[:password])
      render_json user.load_attribute_user, I18n.t("api.session.success")
    else
      render_json nil, I18n.t("api.session.failed"), true, 400
    end
  end
end
