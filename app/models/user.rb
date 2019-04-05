class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_one :warehouse, dependent: :destroy
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

  scope :manager_user, ->{where.not role: "admin"}
  scope :load_user, ->{select :id, :email, :phone, :name, :user_code, :gender, :adress, :birth, :role}

  def login
    @login || phone || email
  end

  def is_me? user
    self == user
  end

  def age
    now = Time.now.utc.to_date
    now.year - birth.year -
      (now.month > birth.month || (now.month == birth.month && now.day >= birth.day) ? 0 : 1)
  end

  class << self
    def find_first_by_auth_conditions warden_conditions
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(phone) = :value OR lower(email) = :value", {value: login.downcase}]).first
      else
        conditions[:username].nil? ? where(conditions).first : where(username: conditions[:username]).first
      end
    end
  end
end
