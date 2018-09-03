class AddPhotoToActors < ActiveRecord::Migration[5.2]
  def change
    add_column :actors, :photo, :string
  end
end
