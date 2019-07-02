class Detail < ApplicationRecord
  belongs_to :ref_detail, polymorphic: true
  belongs_to :product_warehouse

  scope :hash_product_details, ->{joins(:product_warehouse).pluck(:product_id, :id).inject(Hash.new{|h, k| h[k] = []}){|h, (k, v)| h[k] << v; h}}

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
