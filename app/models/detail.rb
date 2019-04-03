class Detail < ApplicationRecord
  belongs_to :ref_detail, polymorphic: true
  has_many :product_warehouses, dependent: :destroy
end
