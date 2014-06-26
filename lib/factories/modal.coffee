CSSUtilities = require '../adapters/css_utilities'


class Modal
  constructor: (@args) ->
    for arg of @args
      @[arg] = @args[arg]

    @container              ?= window.document.body
    @id                     ?= 'dm-modal'
    @behavior               ?= null
    @closeable              ?= true
    @className              ?= ''
    @content                ?= window.document.createTextNode('')
    @contentContainer        = window.document.createElement('div')
    @cookieName             ?= "DasModal.#{@id}.viewed"
    @cookieDomain           ?= @getCookieDomain()
    @expires                ?= @getModalTimeOut()
    @onopen                 ?= ->
    @onclose                ?= ->
    @onready                ?= ->
    @onContentLoaded        ?= ->
    @ontrigger              ?= ->
    @stylesheet             ?= ''
    @css                     = CSSUtilities
    @openClassName           = 'dm-visible'
    @modalClassName          = 'dm-dasmodal'
    @containerClassName      = 'dm-container'
    @contentLoadingClassName = 'dm-content-loading'
    @modal                   = @constructModal()

    @constructModalCSS()
    @constructModalContent()

    if typeof @onready == 'function' then @onready()

    if @isGate() then @trigger()

  isGate: ->
    @behavior == 'gate'

  isCookied: ->
    cookie   = window.document.cookie
    cookieRe = new RegExp "#{@cookieName}=true", 'ig'

    cookieRe.test(cookie);

  isKillable: ->
    !!@closeable

  trigger: ->
    if typeof @ontrigger is 'function'
      @ontrigger()

    if !@isCookied()
      @open()

  open: ->
    _modal = @

    if typeof @onopen is 'function'
      @onopen()

    _modal.setViewedCookie()
    _modal.css.addClassName(_modal.openClassName, _modal.modal)

  close: ->
    _modal = @

    if typeof @onclose is 'function'
      @onclose()

    @css.removeClassName(@openClassName, @modal)

  setViewedCookie: ->
    c = "#{@cookieName}=true;domain=#{@cookieDomain};expires=#{@expires};path=/"
    window.document.cookie = c

  getModalTimeOut: ->
    oneDay    = 24*60*60*1000
    timestamp = (new Date()).getTime()
    new Date(timestamp + oneDay).toUTCString()

  getCookieDomain: ->
    hostArray = window.location.hostname.split('.').reverse()
    hostArray = hostArray.splice(0,2).reverse()
    hostArray.join('.')

  closeAll: (callback) ->
    for modal in window.document.body.querySelectorAll('.dm-container')
      @css.removeClassName(@openClassName, modal)

    if typeof callback is 'function'
      callback()

  constructModal: ->
    modalContainer = @constructModalContainer()
    clickKiller    = @constructClickKiller()
    modalLayout    = @constructModalLayout()

    modalContainer.appendChild(clickKiller)
    clickKiller.appendChild(modalLayout)
    modalLayout.appendChild(@contentContainer)
    @container.appendChild(modalContainer)

    modalContainer

  constructModalCSS: ->
    return unless /\.css/i.test(@stylesheet)

    styles      = window.document.createElement('link');
    styles.type = 'text/styles';
    styles.rel  = 'stylesheet';
    styles.href = @stylesheet;
    window.document.head.appendChild(styles);

  constructModalContainer: ->
    container           = window.document.createElement('div')
    container.id        = @id
    container.className = [@className, @modalClassName, @containerClassName].join(' ')
    container

  constructClickKiller: ->
    killer           = window.document.createElement('div')
    killer.className = 'dm-clickkiller'
    killer.addEventListener("click", ((e) -> @handleKillerClick(e)).bind(this), true)
    killer

  constructModalLayout: ->
    layout           = window.document.createElement('div')
    layout.className = 'dm-layout'
    layout

  constructModalContent: ->
    if @isAjaxContent()
      @contentContainer.className = "dm-content #{@contentLoadingClassName}"
      @loadModalContent()
    else
      @contentContainer.className = "dm-content"
      @contentContainer.appendChild(@content)
      @handleContentLoaded()

  updateModalContent: (content) ->
    html          = @parseHTML(content)
    updateContent = html.querySelectorAll('body > *')

    for node in updateContent
      @contentContainer.appendChild(node)

    @css.removeClassName(@contentLoadingClassName, @contentContainer)

    @handleContentLoaded()

  loadModalContent: ->
    _modal = @
    xhr = new window.XMLHttpRequest
    xhr.open("GET", @content, true)
    xhr.onreadystatechange = ->
      if @readyState != 4 || @status != 200
        return
      _modal.updateModalContent(xhr.responseText)
    xhr.send("r=#{Math.ceil(Math.random() * 10e16)}")

  isAjaxContent: ->
    (typeof @content is 'string') ? true : false

  handleReady: ->
    if typeof @onready is 'function'
      @onready()

  handleContentLoaded: ->
    if typeof @onContentLoaded is 'function'
      @onContentLoaded()

  parseHTML: (content) ->
    html = window.document.implementation.createHTMLDocument("doc")
    html.documentElement.innerHTML = content
    html

  handleKillerClick: (event) ->
    target = event.target
    if @isKillable() and /dm\-(clickkiller|layout)/.test(target.className)
      @close()

module?.exports = Modal
