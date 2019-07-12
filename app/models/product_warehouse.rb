class ProductWarehouse < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  has_many :images, as: :ref_image
  has_many :details, dependent: :destroy

  after_create :update_warehouse
  after_update :update_warehouse

  before_update :update_history

  scope :from_date, (lambda do |mfg|
    where("date(mfg) >= ?", mfg) unless mfg.blank?
  end)

  scope :to_date, (lambda do |exp|
    where("date(exp) <= ?", exp) unless exp.blank?
  end)

  scope :load_images, (lambda do
    imgs = map(&:images).flatten!
    if imgs.blank?
      return first.product.images
    else
      return imgs
    end
  end)

  scope :can_sell, (lambda do |p_id|
    where(product_id: p_id, stop_providing: false).where.not(count: 0).order(created_at: :asc)
  end)

  scope :load_inventory, ->{select("sum(count) total_count, sum(count * price_origin) total_price, product_id").group(:product_id)}

  scope :inventory_count, ->{where(stop_providing: false).sum(:count)}

  scope :inventory_price, ->{where(stop_providing: false).sum("count * price_origin")}

  scope :has_description, ->{where("description <> ''")}

  def of_user user_id
    warehouse.user.id == user_id
  end

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
      from: from_user,
      pw_id: id
    )
  end

  def load_attribute_product url
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
      images: product.load_images(warehouse.user),
      category: product.category.load_structure_detail,
      url: "#{url}/product?u_id=#{warehouse.user.id}&p_id=#{product_id}"
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
  def update_history
    changes = self.changes
    return if changes[:count].nil? && changes[:price_origin].nil?
    h = warehouse.histories.where(pw_id: id).first
    return if h.nil?
    counts = changes[:count]
    if counts
      count = counts[0] - counts[1]
      count.positive? ? h.count -= count.abs : h.count += count.abs
    end
    h.price = price_origin if changes[:price_origin]
    h.save
  end

  def update_warehouse
    warehouse.auto_update
  end
end
