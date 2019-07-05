class Sell < ApplicationRecord
  belongs_to :user
  has_many :details, as: :ref_detail

  scope :from_date, (lambda do |from_date|
    where("date(created_at) >= ?", from_date) unless from_date.blank?
  end)

  scope :to_date, (lambda do |to_date|
    where("date(created_at) <= ?", to_date) unless to_date.blank?
  end)

  scope :between_date, (lambda do |type|
    case type.to_i
    when 1
      where(created_at: Time.current.beginning_of_week..Time.current.end_of_week)
    when 2
      where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
    when 3
      time = Time.current.prev_month
      where(created_at: time.beginning_of_month..time.end_of_month)
    when 4
      where(created_at: Time.current.beginning_of_year..Time.current.end_of_year)
    when 5
      time = Time.current.prev_year
      where(created_at: time.beginning_of_year..time.end_of_year)
    when 6
      all
    else
      if type.include? "/"
        month_year = type.split "/"
        where("MONTH(created_at) = ? AND YEAR(created_at) = ?", month_year[0], month_year[1])
      else
        where("YEAR(created_at) = ?", type)
      end
    end
  end)

  scope :revenue_profit, (lambda do |type, type_group, condition|
    if type_group == 2
      select("#{condition} as date, sum(total_count) as count, sum(total_count * total_price) as revenue")
        .between_date(type)
        .group(condition)
    else
      select("YEAR(created_at) as year, MONTH(created_at) as month, sum(total_count) as count, sum(total_count * total_price) as revenue")
        .between_date(type)
        .group(condition)
    end
  end)

  scope :in_day, ->{where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)}

  scope :yesterday_day, ->{where(created_at: Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day)}

  def sum_count
    details.sum :count
  end

  def sum_price
    details.sum("count * price")
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

  def load_structure
    {
      id: id,
      sell_code: sell_code,
      count: total_count,
      price: total_price,
      description: description,
      created: created_at.localtime.strftime("%Y/%m/%d %H:%M:%S"),
      detail: details.map(&:load_structure)
    }
  end
end
