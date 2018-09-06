class AddTmdbidToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :tmdbid, :integer
  end
end
