class SongsController < ApplicationController

	def new
	end

	def create
		@song = Song.new(song_params)
	  @song.save
	  create_tags(@song)
	  redirect_to songs_path
	end

	def index
		@songs = Song.all
    @songs_hash = @songs.map{ |song| serialize_song(song) }
	end

  def multisong_update
    update_songs if multisong_params.present?
    render status: :ok, nothing: true
  end

private
  def update_songs
    multisong_params.each do |song| 
      stored_song = Song.find(song['id'])
      stored_song.update_attributes(artist: song['artist']) if song['artist'].present? 
      stored_song.update_attributes(title: song['title']) if song['title'].present? 
    end
  end

  def serialize_song(song)
    song.as_json.merge(tags: song.tags).to_json
  end


  def song_params
    params.require(:song).permit(:title, :artist, :url)
  end

  def multisong_params
    JSON.parse(params.require(:songs))
  end

  def create_tags(song)
  	id = trim_url(song.url)
  	resp = JSON.parse(HTTP.get(request_url_str(id)))
    song.update_attributes(name: resp['items'][0]['snippet']['title'])
    return unless resp['items'][0]['snippet']['tags'].present?
  	resp['items'][0]['snippet']['tags'].each do |tagname|
  		Tag.create(name: tagname, song: song)
  	end
  end

  def trim_url(url)
  	(a = url["?v="]) ? url.split("?v=")[1] : url.split("/")[-1]
  end

  def request_url_str(video_id)
    "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=#{video_id}&key=#{youtube_key}"
  end

  def youtube_key
  	Rails.application.secrets.youtube_key
  end

end