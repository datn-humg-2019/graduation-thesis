class Sell < ApplicationRecord
  belongs_to :user
  has_many :details, as: :ref_detail
end
