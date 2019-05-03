class RemoveIndexFromBills < ActiveRecord::Migration[5.2]
  def change
    remove_index :bills, [:from_user_id, :to_user_id]
  end
end
