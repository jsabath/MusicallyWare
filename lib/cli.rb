class Cli
    attr_reader :current_user

    def create_playlist songs
        songs.each do |song|
            playlist = Playlist.create(user_id: @current_user.id, music_id: song.id)
        end
    end

    def add_to_playlist list_of_songs
        if @playlist.nil?
            @playlist = list_of_songs
        else
            @playlist += list_of_songs
        end
    end

    def saturn_image

        puts "
                 ,MMM8&&&.
            _...MMMMM88&&&&..._
         .::'''MMMMM88&&&&&&'''::.
        ::     MMMMM88&&&&&&     ::
        '::....MMMMM88&&&&&&....::'
           `''''MMMMM88&&&&''''`
                 'MMM8&&&'
      "
        puts "\n\n"
    end

    def noon
        noon = Time.now
        noon.change(hour:12)
    end

    def evening
        evening = Time.now
        evening.change(hour:17)
    end

    def welcome
        saturn_image
        puts "Please type in your username:"
        new_username = gets.strip
        new_user = User.create({name: new_username})
        @current_user = User.find_or_create_by(name: new_username)

        t = Time.now
        if t < noon
            puts "Good Morning, #{new_username}!"
        elsif t < evening && t > noon
            puts "Good Afternoon, #{new_username}!"
        else
            puts "Good Evening, #{new_username}."
        end
        main_menu
    end

    

    def main_menu
        prompt = TTY::Prompt.new
        selection = prompt.select("How may I assist you today?", ["New Music", "Preexisting Music", "Clear Music Tastes"])

        case selection
        when "New Music"
             new_music
        when "Preexisting Music"
             preexisting_music
        when "Clear Music Tastes"
             clear_music
        end
    end
    

    

    def new_music
        select_genre(@current_user)
        main_menu
    end
    

    def preexisting_music
        music = Music.joins(:playlists).where("playlists.user_id = ?", @current_user.id)
        pp music
        if music.length == 0
            puts "It looks like you don't have any music interests.. Go to New Music to add some!"
        end
        main_menu
    end

    def clear_music
        Playlist.where(user_id: @current_user.id).each do |playlist|
            playlist.destroy!
        end
        main_menu
    end
    
    
    def select_genre current_user
        genre_list = ["Pop", "Rap", "Rock", "RnB", "Electro"]
        prompt = TTY::Prompt.new 
        selection = prompt.select("Select Genre", genre_list)
        select_artist(selection, current_user)
    end

    def select_artist genre, current_user
        artist_list = MUSIC["#{genre.downcase}_artists"]
        prompt = TTY::Prompt.new 
        selection = prompt.select("Select Artist", artist_list)
        select_songs(genre, selection, current_user)
    end

    def select_songs genre, artist, current_user
        genre_songs = MUSIC["#{genre.downcase}_songs"]
        artist_songs = genre_songs[artist]
        
        songs = artist_songs.map do |song|
            Music.create(song: song, genre: genre, artist: artist)
        end
        create_playlist(songs)
    end


    MUSIC = {
    "pop_artists" => ["Dua Lipa", "The Weeknd", "Doja Cat", "Lady Gaga", "Billie Eilish"],
    "pop_songs" => {"Dua Lipa" => ["Don't Start Now","Physical","Beak My Heart"],
    "The Weeknd" => ["Blinding Lights","In Your Eyes","After Hours"],
    "Doja Cat" => ["Say So","Boss Bitch","Like That"],
    "Lady Gaga" => ["Stupid Love","Shallow","Bad Romance"], 
    "Billie Eilish" => ["everything i wanted","bad guy","No Time To Die"]},


    "rap_artists" => ["Roddy Rich", "Drake", "Travis Scott", "BROCKHAMPTON" , "Lil Uzi Vert"],
    "rap_songs" => {"Roddy Rich" => ["The Box","High Fashion (feat. Mustard)", "Start Wit Me (feat. Gunna)"],
    "Drake" => ["Life Is Good (feat. Future)", "Toosie Slide", "Mob Ties"],
    "Travis Scott" => ["HIGHEST IN THE ROOM", "Can't Say","Sicko Mode"], 
    "BROCKHAMPTON" => ["Sugar","Gold", "Sweet"], 
    "Lil Uzi Vert" => ["Pop", "P2", "Futsal Shuffle 2020"]},

    "rock_artists" => ["Twenty One Pilots", "Machine Gun Kelly", "Imagine Dragons", "Oliver Tree" , "The Killers"],
    "rock_songs" => {"Twenty One Pilots" => ["Stressed Out","Level of Concern", "Ride"],
    "Machine Gun Kelly" => ["I Think I'm OKAY","Candy","Home"],
    "Imagine Dragons" => ["Believer","Thunder","Bad Liar"],
    "Oliver Tree" => ["Alien Boy","Let Me Down","Miracle Man"], 
    "The Killers" => ["Mr.Brightside","When You Were Young","Caution"]},

    "rnb_artists" => ["Doja Cat", "PARTYNEXTDOOR", "The Weeknd", "Khalid" , "6lack"],
    "rnb_songs" => {"Doja Cat" => ["Juicy", "Like That (feat. Gucci Mane)", "Say So"],
    "PARTYNEXTDOOR" => ["LOYAL (feat. Drake", "SPLIT DECISION", "BELIEVE IT"],
    "The Weeknd" => ["Snowchild", "The Morning","Same Old Song"], 
    "Khalid" => ["Know Your Worth", "Better", "Location"], 
    "6lack" => ["Pretty Little Fears (feat. J. Cole)", "East Atlanta Love Letter", "Balenciaga Challenge"]},

    "electro_artists" => ["KSHMR" , "ILLENIUM", "KAAZE", "Flux Pavilion", "Diskord"],
    "electro_songs" => {"KSHMR" => ["My Best Life","Alone","Power"],
    "ILLENIUM" => ["Takeaway","In Your Arms","Feel Good"],
    "KAAZE" => ["I Should Have Walked Away","Devil Inside Me","This Is Love"],
    "Flux Pavilion" => ["Savage","I Can't Stop","Room to Fall"],
    "Diskord" => ["Beggers","U&I","Blood Brother"]}
    }
end

