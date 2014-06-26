DomNodeMock = require './dom_node'

class FormMock
  constructor: ->
    @className = 'tehform'

  addEventListener: ->

  submit: ->

  querySelector: (selector) ->
    element = {}
    switch selector
      when 'input[name="email"]'
        element = new DomNodeMock
          name  : 'email'
          type  : 'email'
          value : 'valid@example.com'
      when 'input[name="invalid-email"]'
        element = new DomNodeMock
          name  : 'email'
          type  : 'email'
          value : 'invalid.email@example'
      when 'input[type="submit"]'
        element = new DomNodeMock
          name : 'submit'
          type : 'submit'
      when '.form-errors'
        element = new DomNodeMock
          nodeName  : 'div'
          className : 'form-errors'
    element

  querySelectorAll: (selector) ->
    [
      @querySelector(selector)
    ]


module?.exports = FormMock
