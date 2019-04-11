class ChangeDescriptionToBeTextInProducts < ActiveRecord::Migration[5.2]
  def change
    change_column :products, :description, :text, null: false, default: nil
  end
end
