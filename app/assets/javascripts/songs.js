var songs;


$( document ).ready(function() {
  
  var substringMatcher = function(strs) {
    return function findMatches(q, cb) {
      var matches, substringRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push(str);
        }
      });

      cb(matches);
    };
  };

  const getName = function(song) {
    return song.name;
  }

  songs = $('#songs').data().songs

  songs.forEach(function(raw_song) {
    song = JSON.parse(raw_song)
    const tags = song.tags.map(getName);

    const config = {
      hint: true,
      highlight: true,
      minLength: 1
    }

    const source = { 
      name: 'tags',
      source: substringMatcher(tags)
    }

    if ($(`#title-${song.id} .typeahead`)[0]) {
      $(`#title-${song.id} .typeahead`).typeahead(config, source);
    }
    if ($(`#artist-${song.id} .typeahead`)[0]) {
      $(`#artist-${song.id} .typeahead`).typeahead(config, source);
    }

  });

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

  $.post("/songs/multisong_update", {songs: JSON.stringify(params)} ,function(resp) {
    location.reload();
  });
}