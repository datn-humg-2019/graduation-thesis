class Api::BillsController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?, except: [:bills_user, :bill_detail]
  before_action :not_admin?, only: [:bills_user, :bill_detail]

  def list_sales_count
    render_json "Lấy dữ liệu thành công", list_sales(true)
  end

  def list_sales_price
    render_json "Lấy dữ liệu thành công", list_sales(false)
  end

  def bills_user
    bills = current_user.vip? ? current_user.sales : current_user.buys
    bills = bills.from_date(params[:from_date]).to_date(params[:to_date]).order(created_at: :desc)

    render_json "Lấy dữ liệu thành công", bills.map{|b| b.load_structure? current_user.vip?}
  end

  def bill_detail
    if params[:bill_id].blank?
      render_json "Dữ liệu ko hợp lệ", nil, 1
    else
      bill = (current_user.vip? ? current_user.sales : current_user.buys).find_by(id: params[:bill_id])
      if bill.nil?
        render_json "Hóa đơn không tồn tại", nil, 1
      else
        render_json "Lấy dữ liệu thành công", bill.details.map(&:load_structure)
      end
    end
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
