class DasBounceProtection
  constructor: (_args) ->
    @args            = _args
    @backjack        = true
    @onlanding       = ->
    @onforwardbutton = ->
    @onbackbutton    = ->
    @onmouseleave    = ->

    if !@isUACompatible()
      return {}

    for arg of @args
      @[arg] = @args[arg]

    if @backjack && @isLanding() && !@isBackjackView()
      @bindBackjack()

    @bindMousejack()

  bindBackjack: ->
    _bounceProtection = this

    window.history.replaceState({ view: 'backjack' }, window.document.title)
    window.history.pushState({ view: 'landing' }, window.document.title)
    window.onpopstate = ->

      if !window.history.state
        return

      switch window.history.state.view
        when 'backjack'
          _bounceProtection.backbutton()
        when 'landing'
          _bounceProtection.forwardbutton()

  bindMousejack: ->
    window.document.addEventListener('mouseout', ((e) -> @handleMouseout(e)).bind(this), true)

  handleMouseout: (e) ->
    if e.clientX < 700 && e.clientY < 1
      @mouseleave()

  mouseleave: ->
    if (typeof @onmouseleave == 'function')
      @onmouseleave()

  backbutton: ->
    if (typeof @onbackbutton == 'function')
      @onbackbutton()

  forwardbutton: ->
    if (typeof @onforwardbutton == 'function')
      @onforwardbutton()

  isBackjackView: ->
    window.history.state && window.history.state.view == 'backjack'

  isLanding: ->
    if window.document.referrer == ""
      true
    if @findDomainTLD() != @findReferrerTLD()
      true
    else
      false

  findDomainTLD: ->
    @_domainToTLD window.location.hostname

  findReferrerTLD: ->
    regExp = /https?:\/\/([^\/$]*)/
    [ head, match, rest... ] = window.document.referrer.match(regExp) || []
    if match?
      @_domainToTLD(match)
    else
      ''

  _domainToTLD: (domain) ->
    domain
      .split('.')
      .reverse()
      .splice(0,2)
      .reverse()
      .join('.')

  isUACompatible: ->
    ('addEventListener' of window.document) && ('pushState' of window.history)

module?.exports = DasBounceProtection
