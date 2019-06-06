class Warehouse < ApplicationRecord
  belongs_to :user
  has_many :product_warehouses, dependent: :destroy
  has_many :histories, dependent: :destroy

  def product_ids
    product_warehouses.pluck :product_id
  end

  def product_inventory
    product_warehouses.where("count > 0 and stop_providing = 0")
  end

  def stop_providing_product product_id, stage
    product_warehouses.find_by(product_id: product_id).update_attributes(stop_providing: stage)
  end

  def stop_providing_category category_id, stage
    product_warehouses.each do |pw|
      pw.update_stop_providing(stage) if pw.product.category_id == category_id
    end
  end

  def sum_count
    product_warehouses.sum :count
  end

  def sum_price_origin
    product_warehouses.sum("count * price_origin")
  end

  def auto_update
    update_attributes total_count: product_warehouses.sum(:count), total_money: product_warehouses.sum("count * price_origin")
  end

  def histories_in_day date
    histories.where("DATE(created_at) = ?", date)
  end

  def all_histories
    histories.select("DATE(created_at) day_input, sum(count) count_input, sum(count * price) price_input").order("day_input desc")
             .group("date(created_at)")
  end

  def detail_history date
    histories.where("DATE(created_at) = ?", date)
  end
end
