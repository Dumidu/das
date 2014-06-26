FormMock = require './form'
DomNodeMock = require './dom_node'

Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class DocumentMock
  constructor: (@args) ->
    for arg of @args
      @[arg] = @args[arg]

    @title             ?= 'Teh Title'
    @_cookie            = ''
    @referrer           = ''
    @location           = hostname : ''
    @head               = new DomNodeMock({tagName: 'head'})
    @body               = new DomNodeMock({tagName: 'body'})
    @forms              = [new FormMock]
    @implementation     = createHTMLDocument: @createHTMLDocument

  addEventListener: ->

  innerHTML: -> '<html></html>'

  createElement: (tagName) ->
    new DomNodeMock
      tagName  : tagName
      nodeName : tagName

  createTextNode: (value) ->
    new DomNodeMock
      tagName  : undefined
      nodeName : '#text'
      value    : value

  createHTMLDocument: (title) ->
    html = new DomNodeMock
      tagName         : undefined
      nodeName        : '#text'
      documentElement : new DocumentMock

  reset: ->
    @_cookie  = ''
    @referrer = ''

  @property 'cookie',
    get : -> @_cookie
    set : (contents) ->
      if contents is ""
        @_cookie = ''
      else
        @_cookie += "#{contents}; "

module?.exports = DocumentMock
