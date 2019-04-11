class Admin::ProductsController < Admin::ApplicationController
  before_action :authenticate_user!
  before_action :get_product, only: %i(show edit update destroy)
  before_action :load_product, only: :index

  def index; end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      save_images params[:product][:image]
      redirect_to admin_products_path
    else
      flash[:danger] = t ".create_fail"
      semester_convert_date
      render :new
    end
  end

  def edit; end

  def update
    if @product.update_attributes product_params
      save_images params[:product][:image]
      redirect_to admin_products_path
    else
      flash[:danger] = t ".update_fail"
      semester_convert_date
      render :edit
    end
  end

  def destroy
    p = @product
    if @product.destroy
      p.images.destroy_all
      flash[:success] = t ".destroy_success"
    else
      flash[:danger] = t ".destroy_fail"
    end
    redirect_to admin_products_path
  end

  private
  def load_product
    @q = Product.ransack(params[:q])
    @products = @q.result.load_product.page(params[:page]).per(3)
  end

  def product_params
    params.require(:product).permit :name, :tag, :description, :category_id
  end

  def semester_convert_date
    @product.birth = convert_date_to_local @product.birth
  end

  def get_product
    @product = Product.find_by id: params[:id]

    return if @product
    flash[:danger] = t "product_not_found"
    redirect_to admin_products_path
  end

  def save_images param
    images = param
    count = 0
    unless images.blank?
      images.each do |i|
        image = @product.images.build
        image.image = i
        count += 1 unless image.save
      end
    end
    if count.zero?
      flash[:success] = t ".create_success"
    else
      # so anh luu fails
      flash[:danger] = t ".create_image_fail"
    end
  end
end
