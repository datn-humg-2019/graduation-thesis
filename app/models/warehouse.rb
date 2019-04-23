class Warehouse < ApplicationRecord
  belongs_to :user
  has_many :product_warehouses, dependent: :destroy

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
end
