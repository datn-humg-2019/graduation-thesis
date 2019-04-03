class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_one :warehouses, dependent: :destroy
  has_many :images, as: :ref_image
  has_many :notifications, dependent: :destroy
  has_many :sells, dependent: :destroy
  has_many :bills, foreign_key: "from_user_id", class_name: Bill.name
  has_many :bills, foreign_key: "to_user_id", class_name: Bill.name
  has_many :active_partners, class_name: Partner.name, foreign_key: :follower_id, dependent: :destroy
  has_many :passive_partners, class_name: Partner.name, foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_partners, source: :followed
  has_many :followers, through: :passive_partners


  attr_writer :login

  validates :name, presence: true
  validates :phone, presence: true

  enum role: {admin: 0, vip: 1, ctv: 2}

  def login
    @login || self.phone || self.email
  end

  class << self
    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(phone) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        if conditions[:username].nil?
          where(conditions).first
        else
          where(username: conditions[:username]).first
        end
      end
    end
  end
end
