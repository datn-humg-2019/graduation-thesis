class Warehouse < ApplicationRecord
  belongs_to :user
  has_many :product_warehouses, dependent: :destroy

  def sum_count
    product_warehouses.sum :count
  end

  def sum_price_origin
    "#{product_warehouses.sum :price_origin} VNĐ"
  end
end
