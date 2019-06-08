class Bill < ApplicationRecord
  belongs_to :to_user, class_name: User.name
  belongs_to :from_user, class_name: User.name
  has_many :details, as: :ref_detail, dependent: :destroy

  validates :from_user, presence: true
  validates :to_user, presence: true

  scope :all_of_user, (lambda do |user_id|
    where(from_user_id: user_id).or(Bill.where(to_user_id: user_id))
  end)

  scope :list_with_date, (lambda do |from_date, to_date|
    where("DATE(bills.created_at) >= ? and Date(bills.created_at) <= ?", from_date, to_date)
  end)

  scope :from_date, (lambda do |from_date|
    where("date(created_at) >= ?", from_date) unless from_date.blank?
  end)

  scope :to_date, (lambda do |to_date|
    where("date(created_at) <= ?", to_date) unless to_date.blank?
  end)

  scope :list_turnover, (lambda do |from_date, to_date, is_count, type_user|
    joins(:details)
    .where("DATE(bills.created_at) >= ? and Date(bills.created_at) <= ?", from_date, to_date)
    .select(is_count ? "#{type_user}, sum(count) total" : "#{type_user}, sum(price) total")
    .group(type_user)
  end)


  scope :data_by_times, (lambda do |from_date, to_date|
    joins(:details)
    .where("DATE(bills.created_at) >= ? and Date(bills.created_at) <= ?", from_date, to_date)
    .select("Date(bills.created_at) date, sum(count) total_count, sum(price) total_price")
    .group("Date(bills.created_at)")
  end)

  def of_user user_id
    from_user_id == user_id || to_user_id == user_id ? true : false
  end

  def total_count
    details.sum :count
  end

  def total_money
    details.sum("count * price")
  end

  def get_info_sales is_count = true
    {
      id: id,
      name: from_user.name,
      turnover: is_count ? total_count : total_money
    }
  end

  def update_pw_to_user
    return unless confirmed
    details.each do |detail|
      pw = detail.product_warehouse
      to_pw = pw.dup
      to_pw.warehouse_id = to_user.warehouse.id
      to_pw.count = detail.count
      to_pw.price_origin = detail.price
      to_pw.price_sale = detail.price
      to_pw.stop_providing = false
      to_pw.save
      to_pw.save_history nil, nil, pw.warehouse.user.id
      pw.count -= detail.count
      pw.save
    end
  end

  def load_structure? vip
    {
      id: id,
      code: bill_code,
      description:  description,
      confirmed: confirmed,
      created: created_at.localtime.strftime("%Y/%m/%d %H:%M:%S"),
      user: vip ? {type: "to user", id: to_user.id,name: to_user.name} : {type: "from user", id: from_user.id,name: from_user.name}
    }
  end
end
