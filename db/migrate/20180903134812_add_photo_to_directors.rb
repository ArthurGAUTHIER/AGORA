class AddPhotoToDirectors < ActiveRecord::Migration[5.2]
  def change
    add_column :directors, :photo, :string
  end
end
