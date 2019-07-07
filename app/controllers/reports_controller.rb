class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:type].to_i == 0
      if current_user.vip?
        bills = current_user.sales.in_day.order(created_at: :desc)
      end
      sells = current_user.sells.in_day.order(created_at: :desc)

      @list = (current_user.vip? ? bills + sells : sells).sort { |b, a|  a.created_at <=> b.created_at }
    else
      ids = current_user.sales.between_date(6).ids
      ids_s = current_user.sells.between_date(6).ids

      if params[:type].to_i == 2
        if current_user.vip?
          bills = Detail.revenue_profit(ids, "Bill", "YEAR(details.created_at)").map{|x| [x.date, [x.count, x.revenue]]}.to_h
          profit_bill = Detail.bill_profit(ids, "YEAR(details.created_at)").map{|x| [x.date, x.profit]}.to_h
        end
        sells = current_user.sells.revenue_profit(6, 2, "YEAR(created_at)").map{|x| [x.date, [x.count, x.revenue]]}.to_h
        profit_sell = Detail.sell_profit(ids_s, "YEAR(details.created_at)").map{|x| [x.date, x.profit]}.to_h
      else
        if current_user.vip?
          bills = Detail.select("YEAR(created_at) as year, MONTH(created_at) as month, sum(count) as count, sum(count * price) as revenue")
                        .by_ref_ids(ids, "Bill").group("YEAR(details.created_at), MONTH(details.created_at)")
                        .map{|x| ["#{x.month}/#{x.year}", [x.count, x.revenue]]}.to_h
          profit_bill = Detail.select("YEAR(details.created_at) as year, MONTH(details.created_at) as month, sum((price - price_origin) * details.count) as profit")
                              .joins(:product_warehouse)
                              .by_bill(ids)
                              .group("YEAR(details.created_at), MONTH(details.created_at)")
                              .map{|x| ["#{x.month}/#{x.year}", x.profit]}.to_h
        end
        sells = current_user.sells.revenue_profit(6, 1, "YEAR(created_at), MONTH(created_at)").map{|x| ["#{x.month}/#{x.year}", [x.count, x.revenue]]}.to_h
        profit_sell = Detail.select("YEAR(details.created_at) as year, MONTH(details.created_at) as month, sum((price - price_origin) * details.count) as profit")
                            .joins(:product_warehouse)
                            .by_sell(ids_s)
                            .group("YEAR(details.created_at), MONTH(details.created_at)")
                            .map{|x| ["#{x.month}/#{x.year}", x.profit]}.to_h
      end
      @revenue = current_user.vip? ? bills.merge(sells){|_key, val1, val2| [val1, val2].transpose.map(&:sum)}.sort : sells
      @profit = current_user.vip? ? profit_bill.merge(profit_sell){|_key, val1, val2| val1 + val2} : profit_sell
    end
  end

  def show
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
