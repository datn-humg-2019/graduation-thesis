class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :content,          null: false
      t.references :users,        foreign_key: true, null: false

      t.timestamps
    end
  end
end
