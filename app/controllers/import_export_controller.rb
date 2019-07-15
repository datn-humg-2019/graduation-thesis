class ImportExportController < ApplicationController
  before_action :authenticate_user!
  before_action :data_reports, only: :export_reports

  def export_template
    respond_to do |format|
      format.html
      format.xlsx{response.headers["Content-Disposition"] = 'attachment; filename="template_import.xlsx"'}
    end
  end

  def import_pw
    import = ImportService.new params[:file], current_user
    import.import
    flash[:success] = "Students imported."
    redirect_to warehouses_path
  end

  def export_reports
    return redirect_to reports_path(date: params[:date]) if @revenue_profit.nil?
    respond_to do |format|
      format.html
      format.xlsx{response.headers["Content-Disposition"] = "attachment; filename='#{params[:date]}_#{Time.current.to_i}.xlsx'"}
    end
  end

  def export_reports_inday
    if current_user.vip?
      bills = current_user.sales.in_day.order(created_at: :desc)
    end
    sells = current_user.sells.in_day.order(created_at: :desc)

    @list = (current_user.vip? ? bills + sells : sells).sort { |b, a|  a.created_at <=> b.created_at }
    respond_to do |format|
      format.html
      format.xlsx{response.headers["Content-Disposition"] = "attachment; filename='today_#{Time.current.to_i}.xlsx'"}
    end
  end

  def export_history
    @history_details = current_user.warehouse.detail_history(params["date"])
    respond_to do |format|
      format.html
      format.xlsx{response.headers["Content-Disposition"] = "attachment; filename=histories_#{params[:date]}_#{Time.current.to_i}.xlsx"}
    end
  end

  private
  def data_reports
    date = params[:date]
    return redirect_to reports_path if date.nil?
    ids = current_user.sales.between_date(date).ids  if current_user.vip?
    ids_s = current_user.sells.between_date(date).ids

    if date.include?("/")
      if current_user.vip?
        bills = Detail.select("DATE(created_at) as date, sum(count) as count, sum(count * price) as revenue")
                      .by_bill(ids).group("DATE(details.created_at)").map{|x| [x.date, [x.count, x.revenue]]}.to_h

        profit_bill = Detail.select("DATE(details.created_at) as date, sum((price - price_origin) * details.count) as profit")
                            .joins(:product_warehouse)
                            .by_bill(ids)
                            .group("DATE(created_at)")
                            .map{|x| [x.date, x.profit]}.to_h

        @bills_detail = bills.merge(profit_bill){|_key, val1, val2| val1 << val2}
      end
      sells = current_user.sells.select("DATE(created_at) as date, sum(total_count) as count, sum(total_count * total_price) as revenue")
                          .between_date(date).group("DATE(created_at)").map{|x| [x.date, [x.count, x.revenue]]}.to_h
      profit_sell = Detail.sell_profit(ids_s, "DATE(details.created_at)").map{|x| [x.date, x.profit]}.to_h

      @sells_detail = sells.merge(profit_sell){|_key, val1, val2| val1 << val2}

      @revenue_profit = if current_user.vip?
                          @bills_detail.merge(@sells_detail){|_key, val1, val2| [val1, val2].transpose.map(&:sum)}
                        else
                          sells
                        end

      @revenue_profit = @revenue_profit.sort.to_h
    else
      if current_user.vip?
        bills = Detail.select("MONTH(created_at) as month, sum(count) as count, sum(count * price) as revenue")
                      .by_bill(ids).group("MONTH(details.created_at)").map{|x| [x.month, [x.count, x.revenue]]}.to_h
        profit_bill = Detail.select("MONTH(details.created_at) as month, sum((price - price_origin) * details.count) as profit")
                            .joins(:product_warehouse)
                            .by_bill(ids)
                            .group("MONTH(created_at)")
                            .map{|x| [x.month, x.profit]}.to_h


        @bills_detail = bills.merge(profit_bill){|_key, val1, val2| val1 << val2}
      end
      sells = current_user.sells.select("MONTH(created_at) as month, sum(total_count) as count, sum(total_count * total_price) as revenue")
                          .between_date(date).group("MONTH(created_at)").map{|x| [x.month, [x.count, x.revenue]]}.to_h
      profit_sell = Detail.sell_profit(ids_s, "MONTH(details.created_at)").map{|x| [x.date, x.profit]}.to_h
      @sells_detail = sells.merge(profit_sell){|_key, val1, val2| val1 << val2}
      @revenue_profit = if current_user.vip?
                          @bills_detail.merge(@sells_detail){|_key, val1, val2| [val1, val2].transpose.map(&:sum)}
                        else
                          sells
                        end

      @revenue_profit = @revenue_profit.sort.to_h
    end
  end
end
