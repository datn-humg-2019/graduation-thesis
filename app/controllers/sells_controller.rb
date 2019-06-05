class SellsController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!
  before_action :get_sell, only: :show

  def index
    params[:to_date] = convert_date params[:to_date] if params[:to_date].present?
    params[:to_date] = convert_date params[:to_date] if params[:to_date].present?
    @q = Sell.ransack(params[:q])
    @sells = current_user.sells.from_date(params[:from_date]).to_date(params[:to_date]).order(created_at: :desc).ransack(params[:q]).result.page(params[:page]).per(20)
  end

  def show
    @details = @sell.details
  end

  def new
    @sell = Sell.new
    @pws = current_user.warehouse.product_warehouses
  end

  def create
    sell = current_user.sells.build sell_params
    sell.sell_code = "BH"
    sell.total_count = 0
    sell.total_price = 0

    if sell.save
      details sell
      flash[:success] = "Bán hàng thành công"
      redirect_to sells_path
    else
      flash[:danger] = "Thất bại"
      render :new
    end
  end

  private
  def sell_params
    params.require(:sell).permit :description
  end

  def details sell
    pws = params[:bill_pw]
    counts = params[:bill_count]
    prices = params[:bill_price].map{|e| convert_price e}
    pws.each_with_index do |pw, i|
      detail = sell.details.build
      detail.product_warehouse_id = pw
      detail.count = counts[i]
      detail.price = prices[i]
      detail.save
    end
    sell.update_product_in_warehouse
    sell.auto_update_attribute
  end

  def get_sell
    @sell = Sell.find_by id: params[:id]

    return if @sell&.of_user(current_user.id)
    flash[:danger] = "sell not found"
    redirect_to sells_path
  end
end
