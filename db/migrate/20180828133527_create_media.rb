class CreateMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :media do |t|
      t.string :title
      t.string :poster
      t.string :trailer
      t.string :synopsys
      t.integer :duration
      t.integer :year
      t.string :country
      t.float :press_rating
      t.float :audience_rating
      t.string :netflix_link
      t.string :amazon_link
      t.string :language
      t.references :studio, foreign_key: true

      t.timestamps
    end
  end
end
