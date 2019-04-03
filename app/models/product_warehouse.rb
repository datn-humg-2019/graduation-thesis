class ProductWarehouse < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  has_many :details, dependent: :destroy
end
