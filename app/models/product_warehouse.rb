class ProductWarehouse < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  has_many :details, dependent: :destroy

  after_create :update_warehouse
  after_update :update_warehouse

  scope :from_date, (lambda do |mfg|
    where("date(mfg) >= ?", mfg) unless mfg.blank?
  end)

  scope :to_date, (lambda do |exp|
    where("date(exp) <= ?", exp) unless exp.blank?
  end)

  scope :load_inventory, ->{select("sum(count) total_count, sum(count * price_origin) total_price, product_id").group(:product_id)}

  scope :inventory_count, ->{where(stop_providing: false).sum(:count)}

  scope :inventory_price, ->{where(stop_providing: false).sum("count * price_origin")}

  def endcode_pw
    "PW-#{id}-#{product_id}"
  end

  def update_stop_providing stage
    update_attributes(stop_providing: stage)
  end

  def save_history p_count = nil, p_price = nil, from_user = nil
    warehouse.histories.create!(
      count: p_count.nil? ? count : p_count,
      price: p_price.nil? ? price_origin : p_price,
      product_id: product_id,
      from: from_user
    )
  end

  def load_attribute_product
    {
      id: product_id,
      name: product.name,
      code: endcode_pw,
      count: count,
      price_origin: price_origin,
      price_sale: price_sale,
      mfg: mfg,
      exp: exp,
      decription: product.description,
      stop_providing: stop_providing,
      images: product.load_images,
      category: product.category.load_structure_detail
    }
  end

  def load_simple_product
    {
      id: product_id,
      name: product.name,
      code: endcode_pw,
      images: product.get_thumb_image.image.url
    }
  end

  class << self
    def get_field_ex_im
      ["STT", "Product", "Count", "Price origin", "Price sale", "mfg", "exp"]
    end

    def get_field_temp
      ["1", "Product name", "1", "100000", "120000", "2019/04/30", "2019/09/30"]
    end
  end

  private
  def update_warehouse
    warehouse.auto_update
  end
end
