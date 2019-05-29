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

  def endcode_pw
    "PW-#{id}-#{product_id}"
  end

  def save_history p_count = nil, p_price = nil, from_user = nil
    warehouse.histories.create!(
      count: p_count.nil? ? count : p_count,
      price: p_price.nil? ? price_origin : p_price,
      product_id: product_id,
      from: from_user
    )
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
