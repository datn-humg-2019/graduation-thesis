class UsersController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!
  before_action :get_user, only: [:show]

  def show
    repond_js
  end

  def edit; end

  def update
    if current_user.update_attributes user_params
      update_avata params[:user][:image]
      flash[:success] = "Cập nhật thành công"
      redirect_to root_path
    else
      flash[:danger] = t ".update_fail"
      render :edit
    end
  end

  private
  def user_params
    params[:user][:birth] = convert_date params[:user][:birth]
    params.require(:user).permit :email, :phone, :name, :gender, :adress, :birth, :role
  end

  def get_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to admin_users_path
  end

  def update_avata image
    return if image.nil?
    current_user.images.destroy_all
    current_user.images.build(image: image).save
  end
end
