class History < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product

  scope :histories_of_user, (lambda do |warehouse_id|
    where(from_user_id: user_id).or(Bill.where(to_user_id: user_id))
  end)
end
