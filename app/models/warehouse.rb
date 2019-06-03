class Warehouse < ApplicationRecord
  belongs_to :user
  has_many :product_warehouses, dependent: :destroy
  has_many :histories, dependent: :destroy

  def product_ids
    product_warehouses.pluck :product_id
  end

  def sum_count
    product_warehouses.sum :count
  end

  def sum_price_origin
    "#{product_warehouses.sum('count * price_origin')} VNĐ"
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
