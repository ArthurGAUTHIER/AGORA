class CreateMediaActors < ActiveRecord::Migration[5.2]
  def change
    create_table :media_actors do |t|
      t.references :medium, foreign_key: true
      t.references :actor, foreign_key: true

      t.timestamps
    end
  end
end
