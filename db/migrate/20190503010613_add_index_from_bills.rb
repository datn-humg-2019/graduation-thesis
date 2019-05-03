class AddIndexFromBills < ActiveRecord::Migration[5.2]
  def change
    add_index :bills, [:from_user_id, :to_user_id]
  end
end
