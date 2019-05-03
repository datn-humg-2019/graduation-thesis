class Detail < ApplicationRecord
  belongs_to :ref_detail, polymorphic: true
  belongs_to :product_warehouse
end
