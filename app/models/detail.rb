class Detail < ApplicationRecord
  belongs_to :ref_detail, polymorphic: true
  belongs_to :product_warehouse

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
