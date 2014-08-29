DocumentMock       = require './document'
HistoryMock        = require './history'
XMLHttpRequestMock = require './xmlhttprequest'

class WindowMock
  constructor: ->
    @console    =
      log      : ->
      warn     : ->
    @document   = new DocumentMock
    @history    = new HistoryMock
    @location   =
      hostname : 'site.com'
      search   : ''
      href     : 'http://site.com'

  XMLHttpRequest: XMLHttpRequestMock

  onpopstate: ->

module?.exports = WindowMock
