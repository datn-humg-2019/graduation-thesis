class Bill < ApplicationRecord
  belongs_to :from_user, class_name: User.name
  belongs_to :to_user, class_name: User.name
  has_many :details, as: :ref_detail

  validates :from_user, presence: true
  validates :to_user, presence: true
end
