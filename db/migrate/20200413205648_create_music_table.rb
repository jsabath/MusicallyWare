class CreateMusicTable < ActiveRecord::Migration[6.0]
  def change
    create_table :musics do |t|
      t.string :song
      t.string :artist
      t.string :genre
    end
  end
end
