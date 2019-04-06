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
    @user.password = @user.default_password
    if @user.save
      flash[:success] = t ".create_success"
      redirect_to admin_users_path
    else
      flash[:danger] = t ".create_fail"
      semester_convert_date
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update_success"
      redirect_to admin_users_path
    else
      flash[:danger] = t ".update_fail"
      semester_convert_date
      render :edit
    end
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
    @users = @q.result.manager_user.load_user.page(params[:page]).per(3)
  end

  def user_params
    params[:user][:birth] = convert_date params[:user][:birth]
    params.require(:user).permit :email, :phone, :name, :gender, :adress, :birth, :role
  end

  def semester_convert_date
    @user.birth = convert_date_to_local @user.birth
  end

  def get_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to admin_users_path
  end
end
