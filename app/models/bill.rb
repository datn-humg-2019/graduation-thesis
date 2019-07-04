class Bill < ApplicationRecord
  belongs_to :to_user, class_name: User.name
  belongs_to :from_user, class_name: User.name
  has_many :details, as: :ref_detail, dependent: :destroy

  validates :from_user, presence: true
  validates :to_user, presence: true

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
    else
      all
    end
  end)

  scope :in_day, ->{where(created_at: Time.current.beginning_of_day..Time.current.end_of_day)}

  scope :yesterday_day, ->{where(created_at: Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day)}

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

  def update_pw_to_user detail_ids
    return unless confirmed
    begin
      arr_details = details.where(id: detail_ids)
      arr_details.each{|d| new_details(d)}

      arr_details.destroy_all
      from_user.warehouse.auto_update
      to_user.warehouse.auto_update
    rescue => error
      puts error.inspect
    end
  end

  def load_structure? vip
    {
      id: id,
      code: bill_code,
      description:  description,
      confirmed: confirmed,
      created: created_at.localtime.strftime("%Y/%m/%d %H:%M:%S"),
      user: vip ? {type: "to user", id: to_user.id, name: to_user.name} : {type: "from user", id: from_user.id, name: from_user.name}
    }
  end

  private

  def new_details detail
    p_id = detail.product_warehouse.product_id

    from_pws = from_user.warehouse.product_warehouses.can_sell(p_id)
    count = detail.count
    price = detail.price

    return if count > from_pws.sum(:count)

    index = 0
    while count.positive?
      pw = from_pws[index]
      count_temp = pw.count <= count ? pw.count : count
      details.build(product_warehouse_id: pw.id, count: count_temp, price: price).save
      pw.decrement!(:count, count_temp)
      index += 1
      count -= count_temp
    end

    to_pw = to_user.warehouse.product_warehouses.build(
      product_id: p_id,
      count: detail.count,
      price_origin: price,
      price_sale: price * 1.1,
      mfg: detail.product_warehouse.mfg,
      exp: detail.product_warehouse.exp,
      stop_providing: false
    )
    to_pw.save!
    to_pw.save_history nil, nil, from_user.id
  end
end
