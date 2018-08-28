class CreateMediaDirectors < ActiveRecord::Migration[5.2]
  def change
    create_table :media_directors do |t|
      t.references :medium, foreign_key: true
      t.references :director, foreign_key: true

      t.timestamps
    end
  end
end
