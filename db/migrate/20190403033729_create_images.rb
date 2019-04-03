class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :image,            null: false
      t.integer :ref_image_id,    null: false
      t.string :ref_image_type,   null: false

      t.timestamps
    end
  end
end
