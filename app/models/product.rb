class Product < ApplicationRecord
  belongs_to :category
  has_many :images, as: :ref_image
  has_many :product_warehouses, dependent: :destroy
  has_many :histories, dependent: :destroy

  scope :load_product, ->{select :id, :name, :description, :tag, :category_id}
  scope :api_load_products, ->{select(:id, :name, :description, :tag, :category_id).map{|p| p.load_structure}}

  scope :list_product_can_add, (lambda do |user|
    where.not(id: user.list_product_id_has).pluck :id, :name
  end)

  scope :get_by_ids, (lambda do |ids|
    where id: ids
  end)

  scope :by_name, (lambda do |name|
    ransack(name_cont: name).result
  end)

  scope :by_id, (lambda do |product_id|
    ransack(id_eq: product_id).result
  end)

  scope :by_category, (lambda do |category_id|
    ransack(category_id_eq: category_id).result
  end)

  scope :by_tag, (lambda do |tag|
    ransack(tag_cont: tag).result
  end)

  def get_images
    images.blank? ? "product.png" : images
  end

  def get_thumb_image
    images.blank? ? "product.png" : images.first
  end

  def load_structure
    result = {
      id: id,
      name: name,
      description: description,
      tag: tag,
      category_id: category_id,
      images: load_images
    }
    result
  end

  def load_images
    arr = []
    images.each do |img|
      url = img.image.url
      url ||= img.image.metadata["url"]
      arr.push url
    end
    arr
  end

  class << self
    def get_list_tag
      pluck(:tag).join(" ").split(" ").uniq.join(" ")
    end
  end
end
