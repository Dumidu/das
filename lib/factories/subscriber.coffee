Carrier = require '../adapters/script_carrier'
CSSUtilities = require '../adapters/css_utilities'

class Subscriber
  constructor: (@args) ->
    for arg of @args
      @[arg] = @args[arg]

    @form              ?= window.document.forms[0]
    @action            ?= @findFormAction()
    @emailSelector     ?= 'input[name="email"]'
    @submitSelector    ?= 'input[type="submit"]'
    @emailElement      ?= @findEmailElement()
    @submitElement     ?= @findSubmitElement()
    @loadingClassName  ?= 'loading'
    @errorClassName    ?= 'error'
    @completeClassName ?= 'complete'
    @onsubmit          ?= ->
    @onerror           ?= ->
    @oncomplete        ?= ->
    @carrierClass       = Carrier
    @carrier            = {}
    @css                = CSSUtilities

    @bindFormSubmit()

  bindFormSubmit: ->
    @form.addEventListener("submit", ((e) -> @handleFormSubmit(e)).bind(this), true)

  handleFormSubmit: (event) ->
    event.preventDefault()

    @updateStatus('loading')

    if @emailIsValid(@getEmail())
      @submit()
    else
      @handleError()

  handleError: ->
    @updateStatus('error')

    if typeof @onerror is 'function'
      @onerror()

  handleComplete: ->
    @updateStatus('complete')

    if typeof @oncomplete is 'function'
      @oncomplete()

  updateStatus: (status) ->
    _subscriber = @

    switch status
      when 'loading'
        @css.removeClassName(_subscriber.errorClassName, _subscriber.form)
        @css.removeClassName(_subscriber.completeClassName, _subscriber.form)
        @css.addClassName(_subscriber.loadingClassName, _subscriber.form)
      when 'error'
        @css.removeClassName(_subscriber.loadingClassName, _subscriber.form)
        @css.addClassName(_subscriber.errorClassName, _subscriber.form)
      when 'complete'
        @css.removeClassName(_subscriber.loadingClassName, _subscriber.form)
        @css.addClassName(_subscriber.completeClassName, _subscriber.form)

  getEmail: ->
    @emailElement.value

  submit: ->
    _subscriber = @
    handleComplete = -> _subscriber.handleComplete()

    if typeof @onsubmit is 'function'
      @onsubmit()

    carrierOptions =
      action   : @action
      params   : @formToCarrierParamsArray()
      callback : handleComplete

    @carrier = new @carrierClass(carrierOptions)
    @carrier.send()

  emailIsValid: (email) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    re.test email

  formToCarrierParams: ->
    elements = @form.elements || []
    params = {}

    for i in elements
      params[i.name] = i.value

    params

  formToCarrierParamsArray: ->
    elements = @form.elements || []
    params = []

    for i in elements
      param = {}
      param[i.name] = i.value
      params.push(param)

    params

  findFormAction: ->
    @form.action

  findEmailElement: ->
    @form.querySelector(@emailSelector)

  findSubmitElement: ->
    @form.querySelector(@submitSelector)

module?.exports = Subscriber
