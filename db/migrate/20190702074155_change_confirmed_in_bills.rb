class ChangeConfirmedInBills < ActiveRecord::Migration[5.2]
  def change
    change_column_null :bills, :confirmed, true
  end
end
