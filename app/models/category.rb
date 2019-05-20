class Category < ApplicationRecord
  has_many :images, as: :ref_image
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :load_categories, ->{select :id, :name}
  scope :api_load_categories, ->{select(:id, :name).map{|ca| ca.load_structure}}

  def get_image
    images.blank? ? "category.png" : images.first.image.url
  end

  def load_structure
    result = {
      id: id,
      name: name,
      image: get_image
    }
    result
  end
end
