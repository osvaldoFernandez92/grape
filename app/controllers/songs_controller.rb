class SongsController < ApplicationController

	def new
	end

	def create
		@song = Song.new(song_params)
	  @song.save
	  update_name(@song)
	  redirect_to songs_path
	end

	def index
		@songs = Song.all
	end

  def update
    Song.find(params[:id]).update_attributes(title: params[:song][:title], artist: params[:song][:artist])
    redirect_to songs_path
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

  def song_params
    params.require(:song).permit(:title, :artist, :url)
  end

  def multisong_params
    JSON.parse(params.require(:songs))
  end

  def update_name(song)
  	id = trim_url(song.url)
  	resp = JSON.parse(HTTP.get(request_url_str(id)))
    song.update_attributes(name: resp['items'][0]['snippet']['title'])
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