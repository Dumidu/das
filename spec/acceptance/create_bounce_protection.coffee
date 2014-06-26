describe 'Feature: Bounce Protection', ->

  describe 'Back Button Bounce Protector', ->

    before ->
      @bounceProtector = new window.DasBounceProtection

    it 'takes action on back button clicks', ->
      sinon.spy(@bounceProtector, 'onbackbutton')
      window.history.state.view = 'backjack'
      window.onpopstate()
      expect(@bounceProtector.onbackbutton.called).to.be true

    it 'takes action on forward button clicks', ->
      sinon.spy(@bounceProtector, 'onforwardbutton')
      window.history.state.view = 'landing'
      window.onpopstate()
      expect(@bounceProtector.onforwardbutton.called).to.be true

    it 'when the page view is a landing it activates', ->
      window.document.referrer = 'http://somedomain.com'
      window.location.hostname = 'differentdomain.com'
      expect(@bounceProtector.isLanding()).to.be true

    it 'when the page view is not a landing it does not activate', ->
      window.document.referrer = 'http://samedomain.com'
      window.location.hostname = 'samedomain.com'
      expect(@bounceProtector.isLanding()).to.be false

    it 'does not hijack a second click of the back button', ->
      sinon.spy(@bounceProtector, 'bindBackjack')
      window.history.state.view ='backjack'
      expect(@bounceProtector.bindBackjack.called).to.be false

  describe 'Mouse Exit Intent Bounce Protector', ->

    it 'detects when a mouse cursor leaves the desktop viewport', ->
      sinon.spy(@bounceProtector, 'onmouseleave')
      @bounceProtector.mouseleave()
      expect(@bounceProtector.onmouseleave.called).to.be true
