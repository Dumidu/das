describe 'Feature: Modal', ->

  describe 'Anywhere Modal', ->

    before ->
      @Stubs = require '../stubs/stubs'

    beforeEach ->
      callback = ->
      window.document.reset()

      @modalOptions =
        id         : 'acceptance-modal',
        onopen     : callback
        stylesheet : '../examples/css/das.css'
        container  : window.document.body

      @modal = new window.DasModal(@modalOptions)

    it 'creates a modal in the DOM', ->
      sinon.spy(@modal.container, 'appendChild')

      @modal.constructModal()
      expect(@modal.container.appendChild.called).to.be true

    it 'loads its own CSS rules', ->
      sinon.spy(window.document.head, 'appendChild')

      @modal.constructModalCSS()
      expect(window.document.head.appendChild.called).to.be true

    it 'can open the modal', ->
      @modal.open()
      expect(@modal.modal.className).to.contain(@modal.openClassName)

    it 'can close the modal', ->
      @modal.close()
      expect(@modal.modal.className).to.not.contain(@modal.openClassName)

    it 'may be triggered externally', ->
      sinon.spy(@modal, 'open')
      @modal.trigger()
      expect(@modal.open.called).to.be true

    it 'sets a cookie when it opens', ->
      @modal.trigger()
      expect(window.document.cookie).to.contain @modal.cookieName

    it 'will not display when cookied (default setting)', ->
      @modal.setViewedCookie()
      @modal.trigger()
      expect(@modal.open.called).to.not.be(true)

    it 'may load content from a URL', ->
      modalOptions = @modalOptions
      modalOptions.content = '/'

      subject = new window.DasModal(modalOptions)
      sinon.spy(subject, 'updateModalContent')

      subject.loadModalContent()
      expect(subject.updateModalContent.called).to.be true

    it 'may be closed by clicking anywhere behind the modal', ->
      sinon.spy(@modal, 'close')
      _event = new @Stubs.EventMock
      _event.target.className = 'dm-clickkiller'

      @modal.handleKillerClick(_event)
      expect(@modal.close.called).to.be true

    it 'calls a callback on trigger', ->
      sinon.spy(@modal, 'ontrigger')
      @modal.trigger()
      expect(@modal.ontrigger.called).to.be true

    it 'calls a callback on open', ->
      sinon.spy(@modal, 'onopen')
      @modal.open()
      expect(@modal.onopen.called).to.be true

    it 'calls a callback on close', ->
      sinon.spy(@modal, 'onclose')
      @modal.close()
      expect(@modal.onclose.called).to.be true

    it 'calls a callback when content is loaded', ->
      sinon.spy(@modal, 'onContentLoaded')
      @modal.updateModalContent('')
      expect(@modal.onContentLoaded.called).to.be true

    it 'may be configured to act as a closable gate', ->
      modalOptions = @modalOptions
      modalOptions.behavior = 'gate'
      subject = new window.DasModal(modalOptions)

      expect(/dm\-visible/gi.test(subject.modal.className)).to.be true

    it 'may be configured to act as a non-closable gate', ->
      modalOptions = @modalOptions
      modalOptions.behavior = 'gate'
      modalOptions.closeable = false
      subject = new window.DasModal(modalOptions)

      sinon.spy(subject, 'close')
      _event = new @Stubs.EventMock
      _event.target.className = 'dm-clickkiller'

      subject.handleKillerClick(_event)
      expect(subject.close.called).to.be false
