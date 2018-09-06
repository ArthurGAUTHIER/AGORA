class ChangeDataColumnTypeOfStores < ActiveRecord::Migration[5.2]
  def change
    change_column :stores, :data, :text
  end
end
