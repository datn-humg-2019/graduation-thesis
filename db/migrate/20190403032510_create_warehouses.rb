class CreateWarehouses < ActiveRecord::Migration[5.2]
  def change
    create_table :warehouses do |t|
      t.integer :total_count,     null: false
      t.float :total_money,       null: false
      t.references :user,        foreign_key: true, null: false

      t.timestamps
    end
  end
end
