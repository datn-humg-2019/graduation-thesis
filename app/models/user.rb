class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_one :warehouse, dependent: :destroy
  has_many :images, as: :ref_image
  has_many :notifications, dependent: :destroy
  has_many :otps, dependent: :destroy
  has_many :sells, dependent: :destroy

  # lấy tất cả những hóa đơn đã xuất hàng
  has_many :sales, class_name: Bill.name, foreign_key: :from_user_id, dependent: :destroy
  # lấy tất cả những hóa đơn nhập hàng
  has_many :buys, class_name: Bill.name, foreign_key: :to_user_id, dependent: :destroy
  # has_many :vip_bills, through: :sale, source: :from_user
  # has_many :ctv_bills, through: :buy, source: :to_user

  has_many :active_partners, class_name: Partner.name, foreign_key: :follower_id, dependent: :destroy
  has_many :passive_partners, class_name: Partner.name, foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_partners, source: :followed
  has_many :followers, through: :passive_partners

  attr_writer :login

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {with: Devise.email_regexp}
  validates :phone, presence: true, uniqueness: true, length: {minimum: 10, maximum: 11},
                    format: {with: /\A(0)[8|9|3|7|5]\d{8,9}/}
  validate :birth_not_than_today

  after_create :create_warehouse

  enum role: {admin: 0, vip: 1, ctv: 2}

  scope :manager_user, ->{where.not role: "admin"}

  scope :ctv_user, ->{where role: "ctv"}
  scope :vip_user, ->{where role: "vip"}

  scope :load_user, ->{select :id, :email, :phone, :name, :gender, :adress, :birth, :role}
  scope :api_load_users, ->{select(:id, :email, :phone, :name, :gender, :adress, :birth, :role).map(&:load_structure)}

  scope :count_user_not_admin, ->{where.not role: "admin"}

  scope :count_user, ->{group(:role).count(:role)}

  def login
    @login || phone || email
  end

  def is_me? user
    self == user
  end

  def get_user_code
    rcode = if admin?
              "A"
            elsif vip?
              "V"
            else
              "C"
            end
    "#{rcode}-#{format('%03d', id)}"
  end

  def check_otp_forgot
    otps.where(otp_type: 0)
  end

  def check_otp otp, type = 0
    otps.where(otp_type: type, otp: otp)
  end

  def age
    return "????" if birth.nil?
    now = Time.now.utc.to_date
    now.year - birth.year -
      (now.month > birth.month || (now.month == birth.month && now.day >= birth.day) ? 0 : 1)
  end

  def default_password
    "#{format('%02d', birth.day)}#{format('%02d', birth.month)}#{birth.year}"
    "123456"
  end

  def get_avatar
    images.blank? ? "avatar.jpg" : images.first.image.thumb.url
  end

  def get_avatar_api
    images.blank? ? "" : images.first.image.url
  end

  def create_warehouse_if_exit
    build_warehouse(total_count: 0, total_money: 0).save if !admin? && !warehouse.present?
  end

  def build_product params
    warehouse.product_warehouses.build params
  end

  def check_has_product product_id
    warehouse.product_warehouses.find_by(product_id: product_id)
  end

  def list_product_id_has
    warehouse.product_warehouses.pluck :product_id
  end

  def get_gender
    case gender
    when true
      "Nam"
    when false
      "Nu"
    else
      "Khac"
    end
  end

  def load_structure
    result = {
      id: id,
      email: email,
      phone: phone,
      name: name,
      gender: get_gender,
      adress: adress,
      birth: birth,
      role: role,
      avatar: get_avatar_api
    }
    result
  end

  def load_attribute_user
    {
      name: name,
      email: email,
      phone: phone,
      gender: get_gender,
      adress: adress,
      birth: birth,
      role: role,
      avatar: get_avatar_api
    }
  end

  def load_token_user
    authorize_token = JsonWebToken.encode user_id: id
    {
      loginToken: authorize_token
    }
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

  private
  def birth_not_than_today
    return if birth.blank?
    errors.add(:base, "Birthday cannot equal than today") if age.negative? || birth.today?
  end

  def create_warehouse
    build_warehouse(total_count: 0, total_money: 0).save unless admin?
  end
end
