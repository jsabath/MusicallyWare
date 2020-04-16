class Music <  ActiveRecord::Base
    belongs_to :playlists
    has_many :users, through: :playlists
end
