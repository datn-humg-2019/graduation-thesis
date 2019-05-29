class AddTypeOtpToOtp < ActiveRecord::Migration[5.2]
  def change
    add_column :otps, :otp_type, :integer, default: 0
  end
end
