class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.string :bill_code,            null: false
      t.integer :from_user_id,        null: false
      t.integer :to_user_id,          null: false
      t.string :description,          null: false
      t.boolean :confirmed,           null: false

      t.timestamps
    end
    add_index :bills, :from_user_id
    add_index :bills, :to_user_id
    add_index :bills, [:from_user_id, :to_user_id], unique: true
  end
end
