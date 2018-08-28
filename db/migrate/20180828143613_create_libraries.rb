class CreateLibraries < ActiveRecord::Migration[5.2]
  def change
    create_table :libraries do |t|
      t.references :user, foreign_key: true
      t.references :medium, foreign_key: true
      t.boolean :seen

      t.timestamps
    end
  end
end
