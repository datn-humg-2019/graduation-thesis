class Bill < ApplicationRecord
  belongs_to :to_user, class_name: User.name
  belongs_to :from_user, class_name: User.name
  has_many :details, as: :ref_detail, dependent: :destroy

  validates :from_user, presence: true
  validates :to_user, presence: true

  scope :all_of_user, (lambda do |user_id|
    where(from_user_id: user_id).or(Bill.where(to_user_id: user_id))
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
      to_pw.save_history
      pw.count -= detail.count
      pw.save
    end
  end
end
