class ScriptCarrier
  constructor: (@args) ->
    for arg of @args
      @[arg] = @args[arg]
    @action         ?= '/'
    @callback       ?= ->
    @callbackParams ?= {}
    @params         ?= {}
    @jsonpHandle    ?= @constructJsonpHandler()
    @carrier         = @constructCarrier()

  constructJsonpHandler: ->
    jsonpHandle         = "jsonp#{Math.ceil(Math.random() * 10e8)}"
    window[jsonpHandle] = @callback
    jsonpHandle

  send: ->
    window.document.body.appendChild(@carrier)

  constructCarrier: ->
    _subscriber    = @
    carrier        = window.document.createElement('script')
    carrier.async  = true
    carrier.src    = @buildCarrierSrc()
    carrier

  buildCarrierSrc: ->
    @params['r']        = Math.ceil(Math.random() * 10e8)
    @params['callback'] = @jsonpHandle
    "#{@action}?#{@stringifyParams()}"

  stringifyParams: ->
    paramsCollection = []

    for param of @params
      urlParamPair = "#{encodeURIComponent(param)}=#{encodeURIComponent(@params[param])}"
      paramsCollection.push(urlParamPair)

    paramsCollection.join('&')

module?.exports = ScriptCarrier
