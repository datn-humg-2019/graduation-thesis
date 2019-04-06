class RemoveFieldnameFromTablename < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :user_code
  end
end
