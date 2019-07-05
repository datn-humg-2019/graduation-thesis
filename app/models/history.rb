class History < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product

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
      all
    end
  end)

  scope :in_day, ->{where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)}

  scope :yesterday_day, ->{where(created_at: Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day)}

  scope :from_date, (lambda do |from_date|
    where("date(created_at) >= ?", from_date) unless from_date.blank?
  end)

  scope :to_date, (lambda do |to_date|
    where("date(created_at) <= ?", to_date) unless to_date.blank?
  end)

  scope :histories_of_user, (lambda do |_warehouse_id|
    where(from_user_id: user_id).or(Bill.where(to_user_id: user_id))
  end)

  scope :list_his_turnover, (lambda do |from_date, to_date, is_count|
    where("DATE(created_at) >= ? and Date(created_at) <= ?", from_date, to_date)
    .select(is_count ? "warehouse_id, sum(count) total" : "warehouse_id, sum(price) total")
    .group(:warehouse_id)
  end)

  scope :data_by_times, (lambda do |from_date, to_date|
    where("date(created_at) >= ? and date(created_at) <= ?", from_date, to_date)
    .select("Date(created_at) date, sum(count) total_count, sum(price) total_price")
    .group("Date(created_at)")
  end)
end
