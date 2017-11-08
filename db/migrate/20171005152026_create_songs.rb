class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :name
      t.string :music_url
      t.references :user

      t.timestamps
    end
  end
end
