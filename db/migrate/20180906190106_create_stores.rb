class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.jsonb :data

      t.timestamps
    end
  end
end
