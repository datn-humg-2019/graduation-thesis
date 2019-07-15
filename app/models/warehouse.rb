class Warehouse < ApplicationRecord
  belongs_to :user
  has_many :product_warehouses, dependent: :destroy
  has_many :histories, dependent: :destroy

  def product_ids
    product_warehouses.where.not(count: 0).pluck :product_id
  end

  def product_inventory
    product_warehouses.where("count > 0 and stop_providing = 0")
  end

  def stop_providing_product product_id, stage
    product_warehouses.where(product_id: product_id).update_all(stop_providing: stage)
  end

  def auto_providing_product product_id
    pws = product_warehouses.where(product_id: product_id)
    pws.update_all(stop_providing: !pws.first.stop_providing)
  end

  def get_first_pw p_id
    product_warehouses.where(product_id: p_id).first
  end

  def stop_providing_category category_id, stage
    product_warehouses.each do |pw|
      pw.update_stop_providing(stage) if pw.product.category_id == category_id
    end
  end

  def sum_count
    product_warehouses.sum :count
  end

  def sum_count_inventory stop_providing
    product_warehouses.where(stop_providing: stop_providing).sum :count
  end

  def sum_price_inventory stop_providing
    product_warehouses.where(stop_providing: stop_providing).sum("count * price_origin")
  end

  def sum_price_origin
    product_warehouses.sum("count * price_origin")
  end

  def auto_update
    update_attributes total_count: sum_count, total_money: sum_price_origin
  end

  def histories_in_day date
    histories.where("DATE(created_at) = ?", date)
  end

  def all_histories
    histories.select("DATE(created_at) day_input, sum(count) count_input, sum(count * price) price_input").order("day_input desc")
             .group("date(created_at)")
  end

  def all_histories_search_date  from_date, to_date
    histories.from_date(from_date).to_date(to_date)
             .select("DATE(created_at) day_input, sum(count) count_input, sum(count * price) price_input").order("day_input desc")
             .group("date(created_at)")
  end

  def detail_history date
    histories.where("DATE(created_at) = ?", date).order(created_at: :desc)
  end
end
