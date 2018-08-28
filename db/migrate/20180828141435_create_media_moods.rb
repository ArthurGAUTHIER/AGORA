class CreateMediaMoods < ActiveRecord::Migration[5.2]
  def change
    create_table :media_moods do |t|
      t.references :medium, foreign_key: true
      t.references :mood, foreign_key: true

      t.timestamps
    end
  end
end
