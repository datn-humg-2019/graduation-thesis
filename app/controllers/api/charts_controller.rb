class Api::ChartsController < Api::BaseController
  before_action :authenticate_request!
  before_action :check_admin?

  def admin_chart_sales
    render_json "Lấy dữ liệu thành công", list_data_sales(params[:count_day].to_i)
  end

  def admin_chart_buys
    render_json "Lấy dữ liệu thành công", list_data_buys(params[:count_day].to_i)
  end

  private
  def list_data_sales day
    now = DateTime.now.to_date
    datas = History.data_by_times(now - day.day, now)
    set_list datas, day
  end

  def list_data_buys day
    now = DateTime.now.to_date
    datas = Bill.data_by_times(now - day.day, now)
    set_list datas, day
  end

  def set_list datas, day
    counts = []
    prices = []
    days = []
    day.times do |i|
      day = DateTime.now.to_date - i.day
      data = datas.find{|f| f["date"] == day}
      days << day
      if data
        counts << data["total_count"]
        prices << data["total_price"]
      else
        counts << 0
        prices << 0
      end
    end
    {days: days.reverse!, counts: counts.reverse!, prices: prices.reverse!}
  end
end
