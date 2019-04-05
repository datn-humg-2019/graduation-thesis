class CreateSells < ActiveRecord::Migration[5.2]
  def change
    create_table :sells do |t|
      t.string :sell_code,       null: false
      t.integer :total_count,    null: false
      t.float :total_price,      null: false
      t.string :description,     null: false
      t.references :user,       foreign_key: true, null: false

      t.timestamps
    end
  end
end
