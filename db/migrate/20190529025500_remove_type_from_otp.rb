class RemoveTypeFromOtp < ActiveRecord::Migration[5.2]
  def change
    remove_column :otps, :type
  end
end
