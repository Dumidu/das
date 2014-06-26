class DomNodeMock
  constructor: (_args) ->
    for arg of _args
      @[arg] = _args[arg]
    @className = 'class-name'

  appendChild: (element) ->
    @childNodes ?= []
    @childNodes[element] = new DomNodeMock({tagName: element})

  addEventListener: ->

  querySelector: (selector) ->
    if /^\./.test selector
      [head..., match] = selector.match(/\.([^ ]+)/) || []
      params =
        tagName   : 'div'
        className : match
    else if /^#/.test selector
      [head..., match] = selector.match(/#([^ ]+)/) || []
      params =
        tagName : 'div'
        id      : match
    else
      params =
        tagName : selector
    new DomNodeMock(params)

  querySelectorAll: (selector) ->
    [
      @querySelector(selector)
    ]

module?.exports = DomNodeMock
