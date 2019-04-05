class Admin::UsersController < Admin::ApplicationController
  before_action :authenticate_user!
  before_action :get_user, only: %i(show edit update destroy)
  before_action :load_user, only: :index

  def index; end

  def show
    repond_js
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    flash[:success] = t ".create_success" if @user.save
  end

  def edit; end

  def update
    result = @user.admin?
    flash[:success] = t ".update_success" if result
  end

  def destroy
    if @user.admin? || @user.is_me?(current_user)
      flash[:danger] = t ".cant_do_it"
    elsif @user.destroy
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_fail"
    end
    redirect_to admin_users_path
  end

  private
  def load_user
    @q = User.ransack(params[:q])
    @users = @q.result.manager_user.load_user#.page(params[:page])
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :role
  end

  def get_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to admin_users_path
  end
end
