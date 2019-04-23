class Product < ApplicationRecord
  belongs_to :category
  has_many :images, as: :ref_image
  has_many :product_warehouses, dependent: :destroy

  scope :load_product, ->{select :id, :name, :description, :tag, :category_id}

  scope :list_product_can_add, (lambda do |user|
    where.not(id: user.list_product_id_has).pluck :id, :name
  end)

  scope :get_by_ids, (lambda do |ids|
    where id: ids
  end)

  scope :by_name, (lambda do |name|
    ransack(name_cont: name).result
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

  class << self
    def get_list_tag
      pluck(:tag).join(" ").split(" ").uniq.join(" ")
    end
  end
end
