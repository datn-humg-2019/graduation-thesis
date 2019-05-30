class BillsController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!
  before_action :get_bill, only: [:show, :update_confirmed]

  def index
    @q = Bill.ransack(params[:q])
    @bills = get_bills.order(:confirmed).ransack(params[:q]).result.page(params[:page]).per(20)
  end

  def show
    @details = @bill.details
  end

  def new
    if current_user.vip?
      @bill = Bill.new
      @pws = current_user.warehouse.product_warehouses
    else
      @bill = Bill.new(from_user_id: params[:from_user_id])
      @pws = User.find_by(id: params[:from_user_id]).warehouse.product_warehouses
    end
  end

  def create
    if current_user.vip?
      bill = current_user.sales.build bill_params_sale
      bill.bill_code = "XH"
      bill.confirmed = true
    else
      bill = current_user.buys.build bill_params_buys
      bill.bill_code = "NH"
      bill.confirmed = false
    end
    if bill.save
      details bill
      flash[:success] = t ".create_success"
      redirect_to bills_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  def select_from_user; end

  def update_confirmed
    if true? params[:confirm]
      @bill.confirmed = true
      @bill.save
      @bill.update_pw_to_user
    end
    redirect_to bills_path
  end

  private
  def bill_params_sales
    params.require(:bill).permit :to_user_id, :description
  end

  def bill_params_buys
    params.require(:bill).permit :from_user_id, :description
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

  def get_bills
    current_user.vip? ? current_user.sales : current_user.buys
  end
end
