class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.integer :count,           null: false
      t.float :price,             null: false
      t.integer :from,            null: true
      t.references :product,      foreign_key: true, null: false
      t.references :warehouse,    foreign_key: true, null: false


      t.timestamps
    end
  end
end
