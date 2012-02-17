define ['backbone', 'cs!search'], (Backbone, Search) ->

  sp = getSpotifyApi 1
  views = sp.require "sp://import/scripts/api/views"
  ui = sp.require "sp://import/scripts/ui"

  class DJ extends Backbone.Model
    initialize: () ->
      this.name = "test"

  class DJs extends Backbone.Collection
    model: DJ

  djs = new DJs()

  class DJView extends Backbone.View
    template: _.template '<li><%= name %></li>'
    render: () =>
      return @template @model.toJSON()

  class DJList extends Backbone.View
    initialize: () ->
      djs.on 'add', @render
    el: "#dj-list"
    render: (dj) =>
      djView = new DJView({model: dj})
      @$el.append djView.render()

  init = () ->
    djs = new DJs()
    djsView = new DJList()
    socket = io.connect 'http://localhost:7070'
    socket.on 'djs', (data) ->
      _(data).each (jsonDJ) ->
        dj = new DJ()
        dj.set(jsonDJ)
        djs.add(dj)

   {init: init}
