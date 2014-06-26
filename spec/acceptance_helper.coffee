global?.expect = require 'expect.js'
global?.sinon  = require 'sinon'

global?.Stubs = require './stubs/stubs'
global?.window = new Stubs.WindowMock
global?.ajax   = {}

require '../lib/das'
