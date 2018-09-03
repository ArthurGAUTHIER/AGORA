class CreatePreferenceDurations < ActiveRecord::Migration[5.2]
  def change
    create_table :preference_durations do |t|
      t.references :user, foreign_key: true
      t.integer :min_duration
      t.integer :max_duration

      t.timestamps
    end
  end
end
