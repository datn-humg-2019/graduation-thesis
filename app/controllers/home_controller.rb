class HomeController < ApplicationController
  before_action :check_admin
  before_action :authenticate_user!

  def index
    @warehouse = current_user.warehouse
    @count_output = output_day.to_i
    @count_output_yesterday = output_day(false).to_i
    @count_input = @warehouse.histories.in_day.sum(:count).to_i
    @count_input_yesterday = @warehouse.histories.yesterday_day.sum(:count).to_i
  end

  def chart_io
    respond_to do |format|
      format.json{render json: date_to_datas(params[:type])}
    end
  end

  private
  def output_day today = true
    if today
      count = current_user.sells.in_day.sum(:total_count)
      count + Detail.by_ref_ids(current_user.sales.in_day.ids, "Bill").sum(:count) if current_user.vip?
    else
      count = current_user.sells.yesterday_day.sum(:total_count)
      count + Detail.by_ref_ids(current_user.sales.yesterday_day.ids, "Bill").sum(:count) if current_user.vip?
    end
  end

  def date_to_datas type
    type = type.to_i
    if [1, 2, 3].include? type
      sell = current_user.sells.between_date(type).group("DATE(created_at)").sum(:total_count)
      bill = Detail.by_ref_ids(current_user.sales.between_date(type).ids, "Bill").group("DATE(created_at)").sum(:count)
      list_i = current_user.warehouse.histories.between_date(type).group("DATE(created_at)").sum(:count)
    elsif [1, 2, 3].include? type
      sell = current_user.sells.between_date(type).group("MONTH(created_at)").sum(:total_count)
      bill = Detail.by_ref_ids(current_user.sales.between_date(type).ids, "Bill").group("MONTH(created_at)").sum(:count)
      list_i = current_user.warehouse.histories.between_date(type).group("MONTH(created_at)").sum(:count)
    else
      sell = current_user.sells.between_date(type).group("YEAR(created_at)").sum(:total_count)
      bill = Detail.by_ref_ids(current_user.sales.between_date(type).ids, "Bill").group("YEAR(created_at)").sum(:count)
      list_i = current_user.warehouse.histories.between_date(type).group("YEAR(created_at)").sum(:count)
    end
    list_o = sell.merge(bill){|_key, val1, val2| val1 + val2}

    time = Time.current

    case type
    when 1
      return {
        list_o: lst_with_loop(time.beginning_of_week.to_date, time.end_of_week.to_date, list_o),
        list_i: lst_with_loop(time.beginning_of_week.to_date, time.end_of_week.to_date, list_i)
      }
    when 2
      return {
        list_o: lst_with_loop(time.beginning_of_month.to_date, time.end_of_month.to_date, list_o),
        list_i: lst_with_loop(time.beginning_of_month.to_date, time.end_of_month.to_date, list_i)
      }
    when 3
      time = time.prev_month
      return {
        list_o: lst_with_loop(time.beginning_of_month.to_date, time.end_of_month.to_date, list_o),
        list_i: lst_with_loop(time.beginning_of_month.to_date, time.end_of_month.to_date, list_i)
      }
    when 4, 5
      return {
        list_o: lst_with_loop(1, 12, list_o),
        list_i: lst_with_loop(1, 12, list_i)
      }
    else
      return {
        label_year: [2017, 2018, 2019],
        list_o: lst_with_loop(2017, 2019, list_o),
        list_i: lst_with_loop(2017, 2019, list_i)
      }
    end
  end

  def lst_with_loop start_d, end_d, datas
    lst = []
    start_d.upto(end_d) do |date|
      lst << (datas.include?(date) ? datas[date] : 0)
    end
    lst
  end
end
