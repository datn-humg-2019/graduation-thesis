class CreateProductWarehouses < ActiveRecord::Migration[5.2]
  def change
    create_table :product_warehouses do |t|
      t.integer :count,            null: false
      t.float :price_origin,       null: false
      t.float :price_sale,         null: false
      t.datetime :mfg,             null: true, default: DateTime.now.strftime("%Y-%d-%m")
      t.datetime :exp,             null: true, default: DateTime.now.strftime("%Y-%d-%m")
      t.boolean :stop_providing,   null: true, default: false
      t.references :product,      foreign_key: true, null: false
      t.references :warehouse,    foreign_key: true, null: false

      t.timestamps
    end
  end
end
