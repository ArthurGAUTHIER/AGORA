class RenameStoresToChienGeants < ActiveRecord::Migration[5.2]
  def change
    rename_table :stores, :chiengeants
  end
end
