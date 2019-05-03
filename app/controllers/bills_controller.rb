class BillsController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!
  before_action :get_bill, only: :show

  def index
    @q = Bill.ransack(params[:q])
    @bills = current_user.sales.ransack(params[:q]).result.page(params[:page]).per(20)
  end

  def show; end

  def new
    @bill = Bill.new
    @pws = current_user.warehouse.product_warehouses
  end

  def create
    bill = current_user.sales.build bill_params
    bill.bill_code = "XH"
    bill.confirmed = true
    if bill.save
      details bill
      flash[:success] = t ".create_success"
      redirect_to bills_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  private
  def bill_params
    params.require(:bill).permit :to_user_id, :description
  end

  def details bill
    pws = params[:bill_pw]
    counts = params[:bill_count]
    prices = params[:bill_price].map{|e| convert_price e}
    pws.each_with_index do |pw, i|
      detail = bill.details.build
      detail.product_warehouse_id = pw
      detail.count = counts[i]
      detail.price = prices[i]
      detail.save
    end
    bill.update_pw_to_user
  end

  def get_bill
    @bill = Bill.find_by id: params[:id]

    return if @bill&.of_user(current_user.id)
    flash[:danger] = t "bill_not_found"
    redirect_to bills_path
  end
end
