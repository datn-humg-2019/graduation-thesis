class Sell < ApplicationRecord
  belongs_to :user
  has_many :details, as: :ref_detail

  scope :from_date, (lambda do |from_date|
    where("date(created_at) >= ?", from_date) unless from_date.blank?
  end)

  scope :to_date, (lambda do |to_date|
    where("date(created_at) <= ?", to_date) unless to_date.blank?
  end)

  def sum_count
    details.sum :count
  end

  def sum_price
    details.sum('count * price')
  end

  def auto_update_attribute
    update_attributes total_count: details.sum(:count), total_price: details.sum("count * price")
  end

  def update_product_in_warehouse
    details.each do |detail|
      pw = detail.product_warehouse
      pw.count -= detail.count
      pw.save
    end
  end

  def of_user user_id
    user_id == user_id
  end
end
