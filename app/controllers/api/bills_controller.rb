class Api::BillsController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?

  def list_sales_count
    render_json "Lấy dữ liệu thành công", list_sales(true)
  end

  def list_sales_price
    render_json "Lấy dữ liệu thành công", list_sales(false)
  end

  private
  def list_sales count
    list_sale = Bill.list_turnover(params[:fromDate], params[:toDate], count, "from_user_id")
                    .map{|b| {id: b.from_user.id, name: b.from_user.name, image: b.from_user.get_avatar_api, turnover: b.total}}
    list_sale.sort{|a, b| b[:turnover] <=> a[:turnover]}
  end

  def list_buys count
    list_sale = Bill.list_turnover(params[:fromDate], params[:toDate], count, "from_user_id")
                    .map{|b| {id: b.from_user.id, name: b.from_user.name, image: b.from_user.get_avatar_api, turnover: b.total}}
    list_sale.sort{|a, b| b[:turnover] <=> a[:turnover]}
  end
end
