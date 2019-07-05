class Detail < ApplicationRecord
  belongs_to :ref_detail, polymorphic: true
  belongs_to :product_warehouse

  scope :hash_product_details, ->{joins(:product_warehouse).pluck(:product_id, :id).inject(Hash.new{|h, k| h[k] = []}){|h, (k, v)| h[k] << v; h}}

  scope :by_ref_ids, (lambda do |ids, name|
    where ref_detail_id: ids, ref_detail_type: name
  end)

  scope :by_bill, (lambda do |ids|
    where ref_detail_id: ids, ref_detail_type: "Bill"
  end)

  scope :by_sell, (lambda do |ids|
    where ref_detail_id: ids, ref_detail_type: "Sell"
  end)

  scope :revenue_profit, (lambda do |ids, type, condition|
    select("#{condition} as date, sum(count) as count, sum(count * price) as revenue")
      .by_ref_ids(ids, type)
      .group(condition)
  end)

  scope :bill_profit, (lambda do |ids, condition|
    select("#{condition} as date, sum((price - price_origin) * details.count) as profit")
      .joins(:product_warehouse).by_bill(ids)
      .group(condition)
  end)

  scope :sell_profit, (lambda do |ids, condition|
    select("#{condition} as date, sum((price - price_origin) * details.count) as profit")
      .joins(:product_warehouse).by_sell(ids)
      .group(condition)
  end)

  def load_structure
    {
      id: id,
      count: count,
      price: price,
      product_warehouse_id: product_warehouse.load_simple_product
    }
  end

  def total
    count * price
  end
end
