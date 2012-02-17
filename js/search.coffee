define ['backbone'], (BackBone) ->

  sp = getSpotifyApi 1
  models = sp.require "sp://import/scripts/api/models"
  views = sp.require("sp://import/scripts/api/views");
  ui = sp.require("sp://import/scripts/ui");

  class SearchList extends Backbone.Collection

  searchList = new SearchList()

  class SearchTrack extends Backbone.Model

  class SearchTrackView extends Backbone.View
    render: () =>
      track = @model.get("track")
      return track.title.decodeForHTML()

  class SearchListView extends Backbone.View
    el: "#song-list"
    initialize: () ->
      searchList.on 'add', @render
    render: (searchTrack) =>
      console.log "added"
      view = new SearchTrackView {model: searchTrack}
      console.log @$el
      console.log view.render()
      console.log "end"
      @$el.append view.render()

  class SearchView extends Backbone.View
    el: "#song_selector"
    events:
      "keypress": "keypress"
    keypress: (event) ->
      if event.charCode == 13
        query = ($ event.target).val()
        search = new models.Search query
        search.localResults = models.LOCALSEARCHRESULTS.APPEND
        search.observe models.EVENT.CHANGE, () =>
          result_count = search.tracks.length;
          console.log("found " + result_count + " tracks for ")
          _(search.tracks).each (track) ->
            searchTrack = new SearchTrack({track: track})
            console.log searchTrack
            searchList.add searchTrack
        search.appendNext()

  searchView = new SearchView()
  searchListView = new SearchListView()

  {searchView: searchView}