var songs;


$( document ).ready(function() {
  

  const getName = function(song) {
    return song.name;
  }

});


const submitSongs = function() {
  var params = [];
  songs.forEach(function(raw_song) {
    song = JSON.parse(raw_song)
    debugger;
    param = {
      id: song.id,
      artist: $(`#artist-${song.id} pre`).text(),
      title: $(`#title-${song.id} pre`).text()
    }
    params.push(param)
  });
  console.log(params);

  //$.post("/songs/multisong_update", {songs: JSON.stringify(params)} ,function(resp) {
  //  location.reload();
  //});
}