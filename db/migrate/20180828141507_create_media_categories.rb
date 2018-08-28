class CreateMediaCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :media_categories do |t|
      t.references :medium, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
