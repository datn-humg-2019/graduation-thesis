class Admin::CategoriesController < Admin::ApplicationController
  before_action :authenticate_user!
  before_action :get_category, only: %i(show edit update destroy)
  before_action :load_categories, only: :index

  def index; end

  def show
    repond_js
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      if params[:category][:image]
        image = @category.images.build
        image.image = params[:category][:image]
        if image.save
          flash[:success] = t ".create_success"
        else
          flash[:danger] = t ".create_image_fail"
        end
      else
        flash[:success] = t ".create_success"
      end
      redirect_to admin_categories_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @category.update_attributes category_params
      @category.images.first.update_attributes(image: params[:category][:image]) if params[:category][:image]
      flash[:success] = t ".update_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t ".update_fail"
      render :edit
    end
  end

  def destroy
    c = @category
    if @category.destroy
      c.images.destroy_all
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_fail"
    end
    redirect_to admin_categories_path
  end

  private
  def load_categories
    @q = Category.ransack(params[:q])
    @categories = @q.result.load_categories.page(params[:page]).per(3)
  end

  def category_params
    params.require(:category).permit :name
  end

  def get_category
    @category = Category.find_by id: params[:id]

    return if @category
    flash[:danger] = t "category_not_found"
    redirect_to admin_categories_path
  end
end
