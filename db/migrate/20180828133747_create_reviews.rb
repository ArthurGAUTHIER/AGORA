class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :medium, foreign_key: true
      t.references :user, foreign_key: true
      t.string :title
      t.string :descritpion

      t.timestamps
    end
  end
end
