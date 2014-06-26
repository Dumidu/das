class XMLHttpRequestMock
  constructor: () ->
    @contents     = {}
    @readyState   = 4
    @status       = 200
    @responseText = 'acceptance'

  open: (method, url, async) ->
    @contents.method = method
    @contents.url    = url
    @contents.async  = async

  setRequestHeader: ->

  onreadystatechange: ->

  send: (payload) ->
    @contents.payload = payload
    @onreadystatechange()

module?.exports = XMLHttpRequestMock
