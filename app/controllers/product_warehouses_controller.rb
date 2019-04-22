class ProductWarehousesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def new; end

  def create
    respond_to do |format|
      pw = current_user.build_product product_warehouse
      pw.stop_providing = false
      notifi = nil
      notifi = if pw.save
                 {message: "input your product success", type: "1"}
               else
                 {message: "input your product failed", type: "3"}
               end
      format.json{render json: {notifi: notifi, product: pw.product.get_thumb_image.image.url}}
    end
  end

  def update
    pw = current_user.check_has_product params[:product_warehouse][:product_id]
    if pw.present?
      pw_temp = ProductWarehouse.new product_warehouse
      pw.count += pw_temp.count
      pw.price_origin = pw_temp.price_sale unless pw_temp.price_origin.zero?
      pw.price_sale = pw_temp.price_origin unless pw_temp.price_sale.zero?
      pw.mfg = pw_temp.mfg unless pw_temp.mfg.nil?
      pw.exp = pw_temp.exp unless pw_temp.exp.nil?
    end
    notifi = nil
    notifi = if pw.save
                {message: "input your product success", type: "1"}
              else
                {message: "input your product failed", type: "3"}
              end
    format.json{render json: {notifi: notifi, product: pw.product.get_thumb_image.image.url}}
  end

  private
  def product_warehouse
    params[:product_warehouse][:mfg] = convert_date params[:product_warehouse][:mfg] if params[:product_warehouse][:mfg].present?
    params[:product_warehouse][:exp] = convert_date params[:product_warehouse][:exp] if params[:product_warehouse][:exp].present?
    params.require(:product_warehouse).permit :count, :price_origin, :price_sale, :mfg, :exp, :product_id
  end
end
