class CreatePreferenceMoods < ActiveRecord::Migration[5.2]
  def change
    create_table :preference_moods do |t|
      t.references :user, foreign_key: true
      t.references :mood, foreign_key: true

      t.timestamps
    end
  end
end
