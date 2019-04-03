class Warehouse < ApplicationRecord
  belongs_to :user
  has_many :product_warehouses, dependent: :destroy
end
