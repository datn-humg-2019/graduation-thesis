class CreateOtps < ActiveRecord::Migration[5.2]
  def change
    create_table :otps do |t|
      t.string :otp,            null: false
      t.integer :type,          null: false
      t.references :user,       foreign_key: true, null: false

      t.timestamps
    end
  end
end
