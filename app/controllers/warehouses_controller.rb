class WarehousesController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!
  before_action :load_warehouse, only: :index

  def index; end

  private
  def load_warehouse
    @warehouse = current_user.warehouse
    params[:mfg] = convert_date params[:mfg] if params[:mfg].present?
    params[:exp] = convert_date params[:exp] if params[:exp].present?
    ids = @warehouse.product_warehouses.from_date(params[:mfg]).to_date(params[:exp]).pluck :product_id
    @products = Product.get_by_ids(ids)
                       .by_category(params[:category_id])
                       .by_name(params[:name])
                       .by_tag(params[:tag])
  end
end
