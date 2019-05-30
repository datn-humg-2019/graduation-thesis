class Api::HistoriesController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?

  def list_buys_count
    render_json "Lấy dữ liệu thành công", list_buys(true)
  end

  def list_buys_price
    render_json "Lấy dữ liệu thành công", list_buys(false)
  end

  private
  def list_buys count
    list_buy = History.list_his_turnover(params[:fromDate], params[:toDate], count)
                      .map{|h| {id: h.warehouse.user.id, name: h.warehouse.user.name, turnover: h.total}}
    list_buy.sort{|a, b| b[:turnover] <=> a[:turnover]}
  end
end
