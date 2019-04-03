class CreatePartners < ActiveRecord::Migration[5.2]
  def change
    create_table :partners do |t|
      t.integer :followed_id,       null: false
      t.integer :follower_id,       null: false
      t.integer :rank,              null: false
      t.float :total_money,         null: false

      t.timestamps
    end
    add_index :partners, :followed_id
    add_index :partners, :follower_id
    add_index :partners, [:followed_id, :follower_id], unique: true
  end
end
