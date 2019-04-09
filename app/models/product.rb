class Product < ApplicationRecord
  belongs_to :category
  has_many :images, as: :ref_image
  has_many :product_warehouses, dependent: :destroy

  scope :load_product, ->{select :id, :name, :description, :tag, :category_id}

  def get_images
    images.blank? ? "product.png" : images
  end

end
