class RemoveProductCodeFromProduct < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :product_code
  end
end
