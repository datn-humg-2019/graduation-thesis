class Admin::DashboardsController < Admin::ApplicationController
  before_action :authenticate_user!
  before_action :load_datas, only: :index

  def index; end

  def count_user
    list_count_user = User.count_user.to_a
    respond_to do |format|
      format.json{render json: {list_count_user: list_count_user}}
    end
  end

  private
  def load_datas
    @datas_lable = {
      total_user: User.count_user_not_admin.size,
      product_inventory: ProductWarehouse.inventory_count,
      price_inventory: ProductWarehouse.inventory_price,
      total_output: Bill.count,
      total_input: History.count
    }
  end
end
