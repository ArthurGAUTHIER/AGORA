class AddColumnsToLibrairies < ActiveRecord::Migration[5.2]
  def change
    add_column :libraries, :already_watched, :boolean, default: false
    add_column :libraries, :watch_later, :boolean, default: false
    add_column :libraries, :blacklist, :boolean, default: false
    remove_column :libraries, :seen, :boolean
  end
end
