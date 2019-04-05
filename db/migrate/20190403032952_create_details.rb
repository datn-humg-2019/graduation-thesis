class CreateDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :details do |t|
      t.integer :count,                  null: false
      t.float :price,                    null: false
      t.integer :ref_detail_id,          null: false
      t.string :ref_detail_type,         null: false
      t.references :product_warehouse,  foreign_key: true, null: false

      t.timestamps
    end
  end
end
