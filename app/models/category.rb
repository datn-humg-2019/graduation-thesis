class Category < ApplicationRecord
  has_many :images, as: :ref_image
  has_many :products, dependent: :destroy
end
