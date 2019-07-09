class ProductWarehousesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!
  before_action :get_pw, only: [:edit, :update]

  def new; end

  def create
    respond_to do |format|
      pw = current_user.build_product product_warehouse
      pw.stop_providing = false
      notifi = nil
      notifi = if pw.save
                 pw.save_history
                 {message: "input your product success", type: "1"}
               else
                 {message: "input your product failed", type: "3"}
               end
      format.json{render json: {notifi: notifi, product: pw.product.get_thumb_image.image.url}}
    end
  end

  def providing_status
    if params["product_id"].blank?
      flash[:danger] = "Dữ liệu ko hợp lệ"
    else
      current_user.warehouse.auto_providing_product params["product_id"].to_i
      flash[:success] = "Cập nhật thành công"
    end
    redirect_to inventories_path
  end

  def get_pw_user
    User.find_by(id: params[:user_id]).warehouse.product_warehouses
  end

  def edit; end

  def update
    if @pw.update_attributes pw_update_params
      flash[:success] = "Cập nhật thành công"
      redirect_to inventories_path
    else
      flash[:danger] = "Cập nhật thất bại"
      render :edit
    end
  end

  private
  def product_warehouse
    params[:product_warehouse][:mfg] = convert_date params[:product_warehouse][:mfg] if params[:product_warehouse][:mfg].present?
    params[:product_warehouse][:exp] = convert_date params[:product_warehouse][:exp] if params[:product_warehouse][:exp].present?
    params.require(:product_warehouse).permit :count, :price_origin, :price_sale, :mfg, :exp, :product_id
  end

  def pw_update_params
    params.require(:product_warehouse).permit :count, :price_origin, :price_sale, :mfg, :exp
  end

  def get_pw
    @pw = ProductWarehouse.find_by id: params[:id]

    return if @pw&.of_user(current_user.id)
    flash[:danger] = t "pw_not_found"
    redirect_to inventories_path
  end
end
