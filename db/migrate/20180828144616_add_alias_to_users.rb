class AddAliasToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :alias, :string
  end
end
