class ProductsController < ApplicationController
  before_action :authenticate_user!, except: :show_product_public
  before_action :get_product, only: :show_product

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      save_images params[:product][:image]
      save_pw @product.id
      redirect_to warehouses_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  def show_product
    repond_js
  end

  def show_product_public
    user = User.find_by id: params[:u_id]
    @pw = user.check_has_product params[:p_id] if user

    return if @pw
    respond_to do |format|
      format.html{render file: "#{Rails.root}/public/500", layout: false, status: :error}
      format.xml{head :not_found}
      format.any{head :not_found}
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
  def product_params
    params.require(:product).permit :name, :tag, :description, :category_id
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
      flash[:danger] = t ".create_image_fail", count: count
    end
  end

  def save_pw product_id
    pw = current_user.warehouse.product_warehouses.build
    pw.product_id = product_id
    pw.count = params[:count_pw]
    pw.price_origin = convert_price params[:price_origin_pw]
    pw.price_sale = convert_price params[:price_sale_pw]
    pw.mfg = convert_date params[:mfg_pw] if params[:mfg_pw].present?
    pw.exp = convert_date params[:exp_pw] if params[:exp_pw].present?
    pw.stop_providing = false
    pw.save
    pw.save_history
  end

  def get_product
    @product = Product.find_by id: params[:id]
    @pw = current_user.check_has_product params[:id]

    return if @product
    flash[:danger] = t "user_not_found"
    redirect_to warehouses_path
  end
end
