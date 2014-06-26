class ScriptCarrier
  constructor: (@args) ->
    for arg of @args
      @[arg] = @args[arg]
    @action         ?= '/'
    @callback       ?= ->
    @callbackParams ?= {}
    @params         ?= {}
    @carrier         = @constructCarrier()

  send: ->
    window.document.body.appendChild(@carrier)

  constructCarrier: ->
    _subscriber    = @
    carrier        = window.document.createElement('script')
    carrier.async  = true
    carrier.onload = ->
      _subscriber.callback()
    carrier.src    = @buildCarrierSrc()
    carrier

  buildCarrierSrc: ->
    @params['r']        = Math.ceil(Math.random() * 10e8)
    @params['callback'] = "jsonp#{Math.ceil(Math.random() * 10e8)}"
    "#{@action}?#{@stringifyParams()}"

  stringifyParams: ->
    paramsCollection = []

    for param of @params
      urlParamPair = "#{encodeURIComponent(param)}=#{encodeURIComponent(@params[param])}"
      paramsCollection.push(urlParamPair)

    paramsCollection.join('&')

module?.exports = ScriptCarrier
