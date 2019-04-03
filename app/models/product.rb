class Product < ApplicationRecord
  belongs_to :category
  has_many :images, as: :ref_image
  has_many :product_warehouses, dependent: :destroy
end
