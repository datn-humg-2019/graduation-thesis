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
      format.json{render json: {notifi: notifi}}
    end
  end

  private
  def product_warehouse
    params[:product_warehouse][:mfg] = convert_date params[:product_warehouse][:mfg] if params[:product_warehouse][:mfg].present?
    params[:product_warehouse][:exp] = convert_date params[:product_warehouse][:exp] if params[:product_warehouse][:exp].present?
    params.require(:product_warehouse).permit :count, :price_origin, :price_sale, :mfg, :exp, :product_id
  end
end
