class BillsController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def index
    @q = Bill.ransack(params[:q])
    @bills = current_user.sales.ransack(params[:q]).result.page(params[:page]).per(20)
  end

  def new
    @bill = Bill.new
  end

  def create

  end

  private
  def bill_params
  end
end
