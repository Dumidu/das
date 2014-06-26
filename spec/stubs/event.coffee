DomNodeMock = require './dom_node'

class EventMock
  constructor: ->
    @target = new DomNodeMock({tagName: 'div'})
  preventDefault: ->

module?.exports = EventMock
