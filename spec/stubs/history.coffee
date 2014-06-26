class HistoryMock
  constructor: ->
    @pushState    = ->
    @state        = { view : '' }
    @replaceState = ->

module?.exports = HistoryMock
