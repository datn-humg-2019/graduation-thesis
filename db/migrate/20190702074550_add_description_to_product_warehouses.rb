class AddDescriptionToProductWarehouses < ActiveRecord::Migration[5.2]
  def change
    add_column :product_warehouses, :description, :text
  end
end
