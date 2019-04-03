class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name,             null: false
      t.string :product_code,     null: false
      t.string :description,      null: true, default: ""
      t.string :tag,              null: true, default: ""
      t.references :categories,   foreign_key: true, null: false

      t.timestamps
    end
  end
end
