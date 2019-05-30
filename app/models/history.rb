class History < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product

  scope :histories_of_user, (lambda do |warehouse_id|
    where(from_user_id: user_id).or(Bill.where(to_user_id: user_id))
  end)

  scope :list_his_turnover, (lambda do |from_date, to_date, is_count|
    where("DATE(created_at) >= ? and Date(created_at) <= ?", from_date, to_date)
    .select(is_count ? "warehouse_id, sum(count) total" : "warehouse_id, sum(price) total")
    .group(:warehouse_id)
  end)
end
