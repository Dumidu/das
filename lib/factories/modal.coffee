CSSUtilities = require '../adapters/css_utilities'


class Modal
  constructor: (@args) ->
    for arg of @args
      @[arg] = @args[arg]

    @container                 ?= window.document.body
    @id                        ?= 'dm-modal'
    @behavior                  ?= null
    @closeable                 ?= true
    @className                 ?= ''
    @content                   ?= window.document.createTextNode('')
    @contentContainer           = window.document.createElement('div')
    @cookieName                ?= "DasModal.#{@id}.viewed"
    @cookieDomain              ?= @getCookieDomain()
    @expires                   ?= @getModalTimeOut()
    @onopen                    ?= ->
    @onclose                   ?= ->
    @onready                   ?= ->
    @onContentLoaded           ?= ->
    @ontrigger                 ?= ->
    @stylesheet                ?= ''
    @css                        = CSSUtilities
    @bodyOpenClassName         ?= 'body-dm-visible'
    @openClassName              = 'dm-visible'
    @modalClassName            ?= 'dm-dasmodal'
    @layoutClassName           ?= 'dm-layout'
    @containerClassName        ?= 'dm-container'
    @clickkillerClassName      ?= 'dm-clickkiller'
    @closeButtonClassName      ?= 'dm-closebutton'
    @contentContainerClassName ?= 'dm-content'
    @contentLoadingClassName    = 'dm-content-loading'
    @modal                      = @constructModal()

    @constructModalCSS()
    @constructModalContent()
    @bindEventListeners()

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

  isClosable: ->
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
    _modal.css.addClassName(_modal.openClassName, _modal.modal)
    _modal.css.addClassName(_modal.bodyOpenClassName, window.document.body)

  close: ->
    _modal = @

    if typeof @onclose is 'function'
      @onclose()

    @css.removeClassName(@openClassName, @modal)
    @css.removeClassName(@bodyOpenClassName, window.document.body)

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
    for modal in window.document.body.querySelectorAll(".#{@openClassName}")
      @css.removeClassName(@openClassName, modal)

    @css.removeClassName(@bodyOpenClassName, window.document.body)

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
    killer.className = @clickkillerClassName
    killer.addEventListener("click", ((e) -> @handleKillerClick(e)).bind(this), true)
    killer

  constructCloseButton: ->
    closeButton           = window.document.createElement('div')
    closeButton.className = @closeButtonClassName
    closeButton.addEventListener("click", ((e) -> @handleCloserClick(e)).bind(this), true)
    closeButton

  constructModalLayout: ->
    layout           = window.document.createElement('div')
    layout.className = @layoutClassName
    layout

  constructModalContent: ->
    if @isAjaxContent()
      @contentContainer.className = "#{@contentContainerClassName} #{@contentLoadingClassName}"
      @loadModalContent()
    else
      @contentContainer.className = @contentContainerClassName
      @contentContainer.appendChild(@content)
      @handleContentLoaded()

  bindEventListeners: ->
    for closeButton in @modal.querySelectorAll("##{@id} .#{@closeButtonClassName}")
      closeButton.addEventListener("click", ((e) -> @handleCloserClick(e)).bind(this), true)

  updateModalContent: (content) ->
    html          = @parseHTML(content)
    updateContent = html.querySelectorAll('body > *')

    for node in updateContent
      @insertFilteredNode(node)

    @css.removeClassName(@contentLoadingClassName, @contentContainer)

    @handleContentLoaded()

  insertFilteredNode: (node) ->
    switch (node.tagName.toLowerCase())
      when 'script' then eval(node.text)
      when 'style' then window.document.head.appendChild(node)
      else @contentContainer.appendChild(node)

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
    if @isKillable() and @isCloserClick(event)
      event.preventDefault()
      @close()

  handleCloserClick: (event) ->
    event.preventDefault()
    if @isClosable() and @isCloserClick(event)
      @close()

  isCloserClick: (event) ->
    clickClass = event.target.className;
    if (clickClass.indexOf(@clickkillerClassName) >= 0)
      return true
    if (clickClass.indexOf(@layoutClassName) >= 0)
      return true
    if (clickClass.indexOf(@closeButtonClassName) >= 0)
      return true
    false

module?.exports = Modal
