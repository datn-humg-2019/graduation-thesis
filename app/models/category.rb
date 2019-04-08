class Category < ApplicationRecord
  has_many :images, as: :ref_image
  has_many :products, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true

  scope :load_categories, ->{select :id, :name}

  def get_image
    images.blank? ? "category.png" : images.first.image.thumb.url
  end
end
