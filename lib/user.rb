class User < ActiveRecord::Base
    has_many :playlists
    has_many :musics, through: :playlists


    

end