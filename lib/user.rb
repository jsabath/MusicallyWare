class User < ActiveRecord::Base
    has_many :playlists
    has_many :music, through: :playlists
    def add_to_playlist list_of_songs
        if @playlist.nil?
            @playlist = list_of_songs
        else
            @playlist += list_of_songs
        end

    end
    def playlist
        if @playlist.nil?
            @playlist = []
        else
            @playlist
        end
    end

    def clear_playlist
        @playlist = []
    end
end