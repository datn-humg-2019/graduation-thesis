class ProductsController < ApplicationController
  before_action :authenticate_user!

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      save_images params[:product][:image]
      redirect_to warehouses_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  def list_tag
    list_tag = Product.get_list_tag
    respond_to do |format|
      format.json{render json: {list_tag: list_tag}}
    end
  end

  def list_product
    list_product = Product.list_product_can_add current_user
    respond_to do |format|
      format.json{render json: {list_product: list_product}}
    end
  end

  private
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
      flash[:danger] = t ".create_image_fail", count: count
    end
  end
end
