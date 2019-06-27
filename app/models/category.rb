class Category < ApplicationRecord
  has_many :images, as: :ref_image
  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :load_categories, ->{select :id, :name}
  scope :api_load_categories, ->{select(:id, :name).map(&:load_structure)}

  def get_image
    images.blank? ? "category.png" : images.first.image.url
  end

  def load_structure stage
    {
      id: id,
      name: name,
      image: get_image,
      stop_providing: stage
    }
  end

  def load_structure_detail
    {
      id: id,
      name: name
    }
  end
end
