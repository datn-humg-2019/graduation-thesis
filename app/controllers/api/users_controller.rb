class Api::UsersController < Api::BaseController
  skip_before_action :authenticate_request!

  def create
    user = User.new user_params
    user.role = "ctv"

    if user.save
      if params[:user][:avatar]
        image = user.images.build
        image.image = params[:user][:avatar]
        image.save
      end
      render_json user.load_attribute_user, I18n.t("api.users.create.create_success")
    else
      render_json nil, user.errors.messages, true, 400
    end
  end

  private
  def user_params
    params.require(:user).permit :email, :phone, :name, :gender, :adress, :birth, :password, :password_confirmation
  end
end
