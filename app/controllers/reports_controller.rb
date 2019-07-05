class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
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

  def show
    # date = params[:date]
    # ids = current_user.sales.between_date(date).ids
    # ids_s = current_user.sells.between_date(date).ids
    # if params[:type].to_i == 2
    #   if current_user.vip?
    #     bills =
    #     bills = Detail.revenue_profit(ids, "Bill", "YEAR(details.created_at)").map{|x| [x.date, [x.count, x.revenue]]}.to_h
    #     profit_bill = Detail.bill_profit(ids, "YEAR(details.created_at)").map{|x| [x.date, x.profit]}.to_h
    #   end
    #   sells = current_user.sells.revenue_profit(6, 2, "YEAR(created_at)").map{|x| [x.date, [x.count, x.revenue]]}.to_h
    #   profit_sell = Detail.sell_profit(ids_s, "YEAR(details.created_at)").map{|x| [x.date, x.profit]}.to_h
    # else
    #   if current_user.vip?
    #     bills = Detail.select("YEAR(created_at) as year, MONTH(created_at) as month, sum(count) as count, sum(count * price) as revenue")
    #                   .by_ref_ids(ids, "Bill").group("YEAR(details.created_at), MONTH(details.created_at)")
    #                   .map{|x| ["#{x.month}/#{x.year}", [x.count, x.revenue]]}.to_h
    #     profit_bill = Detail.select("YEAR(details.created_at) as year, MONTH(details.created_at) as month, sum((price - price_origin) * details.count) as profit")
    #                         .joins(:product_warehouse)
    #                         .by_bill(ids)
    #                         .group("YEAR(details.created_at), MONTH(details.created_at)")
    #                         .map{|x| ["#{x.month}/#{x.year}", x.profit]}.to_h
    #   end
    #   sells = current_user.sells.revenue_profit(6, 1, "YEAR(created_at), MONTH(created_at)").map{|x| ["#{x.month}/#{x.year}", [x.count, x.revenue]]}.to_h
    #   profit_sell = Detail.select("YEAR(details.created_at) as year, MONTH(details.created_at) as month, sum((price - price_origin) * details.count) as profit")
    #                       .joins(:product_warehouse)
    #                       .by_sell(ids_s)
    #                       .group("YEAR(details.created_at), MONTH(details.created_at)")
    #                       .map{|x| ["#{x.month}/#{x.year}", x.profit]}.to_h
    # end
    # @revenue = current_user.vip? ? bills.merge(sells){|_key, val1, val2| [val1, val2].transpose.map(&:sum)}.sort : sells
    # @profit = current_user.vip? ? profit_bill.merge(profit_sell){|_key, val1, val2| val1 + val2} : profit_sell
  end

  private

  def condition type=1
    condition = case type.to_i
                when 1, 0
                  "MONTH(created_at)"
                when 2
                  "YEAR(created_at)"
                else
                  "DATE(created_at)"
                end
    condition
  end
end
