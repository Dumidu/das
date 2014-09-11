(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
(function() {
  if (typeof module !== "undefined" && module !== null) {
    module.exports = {
      addClassName: function(className, target) {
        var classes;
        classes = target.className.split(' ');
        if (classes.indexOf(className) === -1) {
          classes.push(className);
        }
        return target.className = this.validClasses(classes).join(' ');
      },
      removeClassName: function(className, target) {
        var classes, idx;
        classes = target.className.split(' ');
        idx = classes.indexOf(className);
        while (idx !== -1) {
          delete classes[idx];
          idx = classes.indexOf(className);
        }
        return target.className = this.validClasses(classes).join(' ');
      },
      validClasses: function(classes) {
        var className, validClasses, _i, _len;
        validClasses = [];
        for (_i = 0, _len = classes.length; _i < _len; _i++) {
          className = classes[_i];
          if (className) {
            validClasses.push(className);
          }
        }
        return validClasses;
      }
    };
  }

}).call(this);

},{}],2:[function(require,module,exports){
(function() {
  var ScriptCarrier;

  ScriptCarrier = (function() {
    function ScriptCarrier(args) {
      var arg;
      this.args = args;
      for (arg in this.args) {
        this[arg] = this.args[arg];
      }
      if (this.action == null) {
        this.action = '/';
      }
      if (this.callback == null) {
        this.callback = function() {};
      }
      if (this.callbackParams == null) {
        this.callbackParams = {};
      }
      if (this.params == null) {
        this.params = {};
      }
      if (this.jsonpHandle == null) {
        this.jsonpHandle = this.constructJsonpHandler();
      }
      this.carrier = this.constructCarrier();
    }

    ScriptCarrier.prototype.constructJsonpHandler = function() {
      var jsonpHandle;
      jsonpHandle = "jsonp" + (Math.ceil(Math.random() * 10e8));
      window[jsonpHandle] = this.callback;
      return jsonpHandle;
    };

    ScriptCarrier.prototype.send = function() {
      return window.document.body.appendChild(this.carrier);
    };

    ScriptCarrier.prototype.constructCarrier = function() {
      var carrier, _subscriber;
      _subscriber = this;
      carrier = window.document.createElement('script');
      carrier.async = true;
      carrier.src = this.buildCarrierSrc();
      return carrier;
    };

    ScriptCarrier.prototype.buildCarrierSrc = function() {
      this.params['r'] = Math.ceil(Math.random() * 10e8);
      this.params['callback'] = this.jsonpHandle;
      return "" + this.action + "?" + (this.stringifyParams());
    };

    ScriptCarrier.prototype.stringifyParams = function() {
      var param, paramsCollection, urlParamPair;
      paramsCollection = [];
      for (param in this.params) {
        urlParamPair = "" + (encodeURIComponent(param)) + "=" + (encodeURIComponent(this.params[param]));
        paramsCollection.push(urlParamPair);
      }
      return paramsCollection.join('&');
    };

    return ScriptCarrier;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = ScriptCarrier;
  }

}).call(this);

},{}],3:[function(require,module,exports){
(function() {
  if (typeof window !== "undefined" && window !== null) {
    window.DasBounceProtection = require('./factories/bounce_protection');
  }

  if (typeof window !== "undefined" && window !== null) {
    window.DasSubscriber = require('./factories/subscriber');
  }

  if (typeof window !== "undefined" && window !== null) {
    window.DasModal = require('./factories/modal');
  }

}).call(this);

},{"./factories/bounce_protection":4,"./factories/modal":5,"./factories/subscriber":6}],4:[function(require,module,exports){
(function() {
  var DasBounceProtection,
    __slice = [].slice;

  DasBounceProtection = (function() {
    function DasBounceProtection(_args) {
      var arg;
      this.args = _args;
      this.backjack = true;
      this.onlanding = function() {};
      this.onforwardbutton = function() {};
      this.onbackbutton = function() {};
      this.onmouseleave = function() {};
      for (arg in this.args) {
        this[arg] = this.args[arg];
      }
      if (this.backjack && this.isLanding() && !this.isBackjackView()) {
        this.bindBackjack();
      }
      this.bindMousejack();
    }

    DasBounceProtection.prototype.bindBackjack = function() {
      var _bounceProtection;
      _bounceProtection = this;
      window.history.replaceState({
        view: 'backjack'
      }, window.document.title);
      window.history.pushState({
        view: 'landing'
      }, window.document.title);
      return window.onpopstate = function() {
        if (!window.history.state) {
          return;
        }
        switch (window.history.state.view) {
          case 'backjack':
            return _bounceProtection.backbutton();
          case 'landing':
            return _bounceProtection.forwardbutton();
        }
      };
    };

    DasBounceProtection.prototype.bindMousejack = function() {
      return window.document.addEventListener('mouseout', (function(e) {
        return this.handleMouseout(e);
      }).bind(this), true);
    };

    DasBounceProtection.prototype.handleMouseout = function(e) {
      if (e.clientX < 700 && e.clientY < 1) {
        return this.mouseleave();
      }
    };

    DasBounceProtection.prototype.mouseleave = function() {
      if (typeof this.onmouseleave === 'function') {
        return this.onmouseleave();
      }
    };

    DasBounceProtection.prototype.backbutton = function() {
      if (typeof this.onbackbutton === 'function') {
        return this.onbackbutton();
      }
    };

    DasBounceProtection.prototype.forwardbutton = function() {
      if (typeof this.onforwardbutton === 'function') {
        return this.onforwardbutton();
      }
    };

    DasBounceProtection.prototype.isBackjackView = function() {
      return window.history.state && window.history.state.view === 'backjack';
    };

    DasBounceProtection.prototype.isLanding = function() {
      if (window.document.referrer === "") {
        true;
      }
      if (this.findDomainTLD() !== this.findReferrerTLD()) {
        return true;
      } else {
        return false;
      }
    };

    DasBounceProtection.prototype.findDomainTLD = function() {
      return this._domainToTLD(window.location.hostname);
    };

    DasBounceProtection.prototype.findReferrerTLD = function() {
      var head, match, regExp, rest, _ref;
      regExp = /https?:\/\/([^\/$]*)/;
      _ref = window.document.referrer.match(regExp) || [], head = _ref[0], match = _ref[1], rest = 3 <= _ref.length ? __slice.call(_ref, 2) : [];
      if (match != null) {
        return this._domainToTLD(match);
      } else {
        return '';
      }
    };

    DasBounceProtection.prototype._domainToTLD = function(domain) {
      return domain.split('.').reverse().splice(0, 2).reverse().join('.');
    };

    return DasBounceProtection;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = DasBounceProtection;
  }

}).call(this);

},{}],5:[function(require,module,exports){
(function() {
  var CSSUtilities, Modal;

  CSSUtilities = require('../adapters/css_utilities');

  Modal = (function() {
    function Modal(args) {
      var arg;
      this.args = args;
      for (arg in this.args) {
        this[arg] = this.args[arg];
      }
      if (this.container == null) {
        this.container = window.document.body;
      }
      if (this.id == null) {
        this.id = 'dm-modal';
      }
      if (this.behavior == null) {
        this.behavior = null;
      }
      if (this.closeable == null) {
        this.closeable = true;
      }
      if (this.className == null) {
        this.className = '';
      }
      if (this.content == null) {
        this.content = window.document.createTextNode('');
      }
      this.contentContainer = window.document.createElement('div');
      if (this.cookieName == null) {
        this.cookieName = "DasModal." + this.id + ".viewed";
      }
      if (this.cookieDomain == null) {
        this.cookieDomain = this.getCookieDomain();
      }
      if (this.expires == null) {
        this.expires = this.getModalTimeOut();
      }
      if (this.onopen == null) {
        this.onopen = function() {};
      }
      if (this.onclose == null) {
        this.onclose = function() {};
      }
      if (this.onready == null) {
        this.onready = function() {};
      }
      if (this.onContentLoaded == null) {
        this.onContentLoaded = function() {};
      }
      if (this.ontrigger == null) {
        this.ontrigger = function() {};
      }
      if (this.stylesheet == null) {
        this.stylesheet = '';
      }
      this.css = CSSUtilities;
      if (this.bodyOpenClassName == null) {
        this.bodyOpenClassName = 'body-dm-visible';
      }
      this.openClassName = 'dm-visible';
      if (this.modalClassName == null) {
        this.modalClassName = 'dm-dasmodal';
      }
      if (this.layoutClassName == null) {
        this.layoutClassName = 'dm-layout';
      }
      if (this.containerClassName == null) {
        this.containerClassName = 'dm-container';
      }
      if (this.clickkillerClassName == null) {
        this.clickkillerClassName = 'dm-clickkiller';
      }
      if (this.closeButtonClassName == null) {
        this.closeButtonClassName = 'dm-closebutton';
      }
      if (this.contentContainerClassName == null) {
        this.contentContainerClassName = 'dm-content';
      }
      this.contentLoadingClassName = 'dm-content-loading';
      this.modal = this.constructModal();
      this.constructModalCSS();
      this.constructModalContent();
      this.bindEventListeners();
      if (typeof this.onready === 'function') {
        this.onready();
      }
      if (this.isGate()) {
        this.trigger();
      }
    }

    Modal.prototype.isGate = function() {
      return this.behavior === 'gate';
    };

    Modal.prototype.isCookied = function() {
      var cookie, cookieRe;
      cookie = window.document.cookie;
      cookieRe = new RegExp("" + this.cookieName + "=true", 'ig');
      return cookieRe.test(cookie);
    };

    Modal.prototype.isKillable = function() {
      return !!this.closeable;
    };

    Modal.prototype.isClosable = function() {
      return !!this.closeable;
    };

    Modal.prototype.trigger = function() {
      if (typeof this.ontrigger === 'function') {
        this.ontrigger();
      }
      if (!this.isCookied()) {
        return this.open();
      }
    };

    Modal.prototype.open = function() {
      var _modal;
      _modal = this;
      if (typeof this.onopen === 'function') {
        this.onopen();
      }
      _modal.setViewedCookie();
      _modal.css.addClassName(_modal.openClassName, _modal.modal);
      _modal.css.addClassName(_modal.openClassName, _modal.modal);
      return _modal.css.addClassName(_modal.bodyOpenClassName, window.document.body);
    };

    Modal.prototype.close = function() {
      var _modal;
      _modal = this;
      if (typeof this.onclose === 'function') {
        this.onclose();
      }
      this.css.removeClassName(this.openClassName, this.modal);
      return this.css.removeClassName(this.bodyOpenClassName, window.document.body);
    };

    Modal.prototype.setViewedCookie = function() {
      var c;
      c = "" + this.cookieName + "=true;domain=" + this.cookieDomain + ";expires=" + this.expires + ";path=/";
      return window.document.cookie = c;
    };

    Modal.prototype.getModalTimeOut = function() {
      var oneDay, timestamp;
      oneDay = 24 * 60 * 60 * 1000;
      timestamp = (new Date()).getTime();
      return new Date(timestamp + oneDay).toUTCString();
    };

    Modal.prototype.getCookieDomain = function() {
      var hostArray;
      hostArray = window.location.hostname.split('.').reverse();
      hostArray = hostArray.splice(0, 2).reverse();
      return hostArray.join('.');
    };

    Modal.prototype.closeAll = function(callback) {
      var modal, _i, _len, _ref;
      _ref = window.document.body.querySelectorAll("." + this.openClassName);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        modal = _ref[_i];
        this.css.removeClassName(this.openClassName, modal);
      }
      this.css.removeClassName(this.bodyOpenClassName, window.document.body);
      if (typeof callback === 'function') {
        return callback();
      }
    };

    Modal.prototype.constructModal = function() {
      var clickKiller, modalContainer, modalLayout;
      modalContainer = this.constructModalContainer();
      clickKiller = this.constructClickKiller();
      modalLayout = this.constructModalLayout();
      modalContainer.appendChild(clickKiller);
      clickKiller.appendChild(modalLayout);
      modalLayout.appendChild(this.contentContainer);
      this.container.appendChild(modalContainer);
      return modalContainer;
    };

    Modal.prototype.constructModalCSS = function() {
      var styles;
      if (!/\.css/i.test(this.stylesheet)) {
        return;
      }
      styles = window.document.createElement('link');
      styles.type = 'text/styles';
      styles.rel = 'stylesheet';
      styles.href = this.stylesheet;
      return window.document.head.appendChild(styles);
    };

    Modal.prototype.constructModalContainer = function() {
      var container;
      container = window.document.createElement('div');
      container.id = this.id;
      container.className = [this.className, this.modalClassName, this.containerClassName].join(' ');
      return container;
    };

    Modal.prototype.constructClickKiller = function() {
      var killer;
      killer = window.document.createElement('div');
      killer.className = this.clickkillerClassName;
      killer.addEventListener("click", (function(e) {
        return this.handleKillerClick(e);
      }).bind(this), true);
      return killer;
    };

    Modal.prototype.constructCloseButton = function() {
      var closeButton;
      closeButton = window.document.createElement('div');
      closeButton.className = this.closeButtonClassName;
      closeButton.addEventListener("click", (function(e) {
        return this.handleCloserClick(e);
      }).bind(this), true);
      return closeButton;
    };

    Modal.prototype.constructModalLayout = function() {
      var layout;
      layout = window.document.createElement('div');
      layout.className = this.layoutClassName;
      return layout;
    };

    Modal.prototype.constructModalContent = function() {
      if (this.isAjaxContent()) {
        this.contentContainer.className = "" + this.contentContainerClassName + " " + this.contentLoadingClassName;
        return this.loadModalContent();
      } else {
        this.contentContainer.className = this.contentContainerClassName;
        this.contentContainer.appendChild(this.content);
        return this.handleContentLoaded();
      }
    };

    Modal.prototype.bindEventListeners = function() {
      var closeButton, _i, _len, _ref, _results;
      _ref = this.modal.querySelectorAll("#" + this.id + " ." + this.closeButtonClassName);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        closeButton = _ref[_i];
        _results.push(closeButton.addEventListener("click", (function(e) {
          return this.handleCloserClick(e);
        }).bind(this), true));
      }
      return _results;
    };

    Modal.prototype.updateModalContent = function(content) {
      var html, node, updateContent, _i, _len;
      html = this.parseHTML(content);
      updateContent = html.querySelectorAll('body > *');
      for (_i = 0, _len = updateContent.length; _i < _len; _i++) {
        node = updateContent[_i];
        this.insertFilteredNode(node);
      }
      this.css.removeClassName(this.contentLoadingClassName, this.contentContainer);
      return this.handleContentLoaded();
    };

    Modal.prototype.insertFilteredNode = function(node) {
      switch (node.tagName.toLowerCase()) {
        case 'script':
          return eval(node.text);
        case 'style':
          return window.document.head.appendChild(node);
        default:
          return this.contentContainer.appendChild(node);
      }
    };

    Modal.prototype.loadModalContent = function() {
      var xhr, _modal;
      _modal = this;
      xhr = new window.XMLHttpRequest;
      xhr.open("GET", this.content, true);
      xhr.onreadystatechange = function() {
        if (this.readyState !== 4 || this.status !== 200) {
          return;
        }
        return _modal.updateModalContent(xhr.responseText);
      };
      return xhr.send("r=" + (Math.ceil(Math.random() * 10e16)));
    };

    Modal.prototype.isAjaxContent = function() {
      var _ref;
      return (_ref = typeof this.content === 'string') != null ? _ref : {
        "true": false
      };
    };

    Modal.prototype.handleReady = function() {
      if (typeof this.onready === 'function') {
        return this.onready();
      }
    };

    Modal.prototype.handleContentLoaded = function() {
      if (typeof this.onContentLoaded === 'function') {
        return this.onContentLoaded();
      }
    };

    Modal.prototype.parseHTML = function(content) {
      var html;
      html = window.document.implementation.createHTMLDocument("doc");
      html.documentElement.innerHTML = content;
      return html;
    };

    Modal.prototype.handleKillerClick = function(event) {
      if (this.isKillable() && this.isCloserClick(event)) {
        event.preventDefault();
        return this.close();
      }
    };

    Modal.prototype.handleCloserClick = function(event) {
      event.preventDefault();
      if (this.isClosable() && this.isCloserClick(event)) {
        return this.close();
      }
    };

    Modal.prototype.isCloserClick = function(event) {
      var clickClass;
      clickClass = event.target.className;
      if (clickClass.indexOf(this.clickkillerClassName) >= 0) {
        return true;
      }
      if (clickClass.indexOf(this.layoutClassName) >= 0) {
        return true;
      }
      if (clickClass.indexOf(this.closeButtonClassName) >= 0) {
        return true;
      }
      return false;
    };

    return Modal;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = Modal;
  }

}).call(this);

},{"../adapters/css_utilities":1}],6:[function(require,module,exports){
(function() {
  var CSSUtilities, Carrier, Subscriber;

  Carrier = require('../adapters/script_carrier');

  CSSUtilities = require('../adapters/css_utilities');

  Subscriber = (function() {
    function Subscriber(args) {
      var arg;
      this.args = args;
      for (arg in this.args) {
        this[arg] = this.args[arg];
      }
      if (this.form == null) {
        this.form = window.document.forms[0];
      }
      if (this.action == null) {
        this.action = this.findFormAction();
      }
      if (this.emailSelector == null) {
        this.emailSelector = 'input[name="email"]';
      }
      if (this.submitSelector == null) {
        this.submitSelector = 'input[type="submit"]';
      }
      if (this.emailElement == null) {
        this.emailElement = this.findEmailElement();
      }
      if (this.submitElement == null) {
        this.submitElement = this.findSubmitElement();
      }
      if (this.loadingClassName == null) {
        this.loadingClassName = 'loading';
      }
      if (this.errorClassName == null) {
        this.errorClassName = 'error';
      }
      if (this.completeClassName == null) {
        this.completeClassName = 'complete';
      }
      if (this.onsubmit == null) {
        this.onsubmit = function() {};
      }
      if (this.onerror == null) {
        this.onerror = function() {};
      }
      if (this.oncomplete == null) {
        this.oncomplete = function() {};
      }
      this.carrierClass = Carrier;
      this.carrier = {};
      this.css = CSSUtilities;
      this.bindFormSubmit();
    }

    Subscriber.prototype.bindFormSubmit = function() {
      return this.form.addEventListener("submit", (function(e) {
        return this.handleFormSubmit(e);
      }).bind(this), true);
    };

    Subscriber.prototype.handleFormSubmit = function(event) {
      event.preventDefault();
      this.updateStatus('loading');
      if (this.emailIsValid(this.getEmail())) {
        return this.submit();
      } else {
        return this.handleError();
      }
    };

    Subscriber.prototype.handleError = function() {
      this.updateStatus('error');
      if (typeof this.onerror === 'function') {
        return this.onerror();
      }
    };

    Subscriber.prototype.handleComplete = function() {
      this.updateStatus('complete');
      if (typeof this.oncomplete === 'function') {
        return this.oncomplete();
      }
    };

    Subscriber.prototype.updateStatus = function(status) {
      var _subscriber;
      _subscriber = this;
      switch (status) {
        case 'loading':
          this.css.removeClassName(_subscriber.errorClassName, _subscriber.form);
          this.css.removeClassName(_subscriber.completeClassName, _subscriber.form);
          return this.css.addClassName(_subscriber.loadingClassName, _subscriber.form);
        case 'error':
          this.css.removeClassName(_subscriber.loadingClassName, _subscriber.form);
          return this.css.addClassName(_subscriber.errorClassName, _subscriber.form);
        case 'complete':
          this.css.removeClassName(_subscriber.loadingClassName, _subscriber.form);
          return this.css.addClassName(_subscriber.completeClassName, _subscriber.form);
      }
    };

    Subscriber.prototype.getEmail = function() {
      return this.emailElement.value;
    };

    Subscriber.prototype.submit = function() {
      var carrierOptions, handleComplete, _subscriber;
      _subscriber = this;
      handleComplete = function() {
        return _subscriber.handleComplete();
      };
      if (typeof this.onsubmit === 'function') {
        this.onsubmit();
      }
      carrierOptions = {
        action: this.action,
        params: this.formToCarrierParams(),
        callback: handleComplete
      };
      this.carrier = new this.carrierClass(carrierOptions);
      return this.carrier.send();
    };

    Subscriber.prototype.emailIsValid = function(email) {
      var re;
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
    };

    Subscriber.prototype.formToCarrierParams = function() {
      var elements, i, params, _i, _len;
      elements = this.form.elements || [];
      params = {};
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        i = elements[_i];
        params[i.name] = i.value;
      }
      return params;
    };

    Subscriber.prototype.findFormAction = function() {
      return this.form.action;
    };

    Subscriber.prototype.findEmailElement = function() {
      return this.form.querySelector(this.emailSelector);
    };

    Subscriber.prototype.findSubmitElement = function() {
      return this.form.querySelector(this.submitSelector);
    };

    return Subscriber;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = Subscriber;
  }

}).call(this);

},{"../adapters/css_utilities":1,"../adapters/script_carrier":2}]},{},[3])