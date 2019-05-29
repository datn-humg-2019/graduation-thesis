class Api::UsersController < Api::BaseController
  # skip_before_action :authenticate_request!, only: :create
  before_action :authenticate_request!, only: [:index, :create_account, :show]
  before_action :check_admin?, only: [:index, :create_account]

  def index
    users = User.api_load_users
    render_json users, "get user succsess"
  end

  def show
    render_json current_user.load_attribute_user, "Lấy dữ liệu thành công"
  end

  def create_account
    user = User.new user_params false
    user.password = user.default_password
    if user.save
      user.images.create!(image: params[:user][:avatar])
      render_json User.find(user.id).load_structure, "create success"
    else
      render_json nil, user.errors.messages, true, 400
    end
  end

  def create
    user = User.new user_params true
    user.role = "ctv"

    if user.save
      if params[:user][:avatar]
        image = user.images.build
        image.image = params[:user][:avatar]
        image.save
      end
      render_json user.load_attribute_user, "Tạo tài khoản thành công"
    else
      render_json nil, user.errors.messages, 1
    end
  end

  def forgot_password
    email = params[:email]
    sendMailForgotPass email
    render_json nil, "Thành công, vui lòng kiểm tra email", 0
  end

  private
  def user_params signup
    if signup
      params.require(:user).permit :email, :phone, :name, :gender, :adress, :birth, :password, :password_confirmation
    else
      params.require(:user).permit :email, :phone, :name, :gender, :adress, :birth, :role
    end
  end
end
