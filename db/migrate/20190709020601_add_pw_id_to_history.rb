class AddPwIdToHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :pw_id, :integer
  end
end
