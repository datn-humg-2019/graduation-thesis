class ProductWarehouse < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
  has_many :details, dependent: :destroy

  after_create :update_warehouse
  after_update :update_warehouse

  scope :from_date, (lambda do |mfg|
    where("date(mfg) >= ?", mfg)
  end)

  scope :to_date, (lambda do |exp|
    where("date(exp) <= ?", exp)
  end)

  private
  def update_warehouse
    warehouse.auto_update
  end
end
