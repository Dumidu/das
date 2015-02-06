describe 'Feature: Async Library Queue', ->

  before ->
    @Stubs = require '../stubs/stubs'

  describe 'when a queue is created', ->

    beforeEach ->
      @testSpy  = sinon.spy()
      @testPush = [
        @testSpy,
        'DOMContentLoaded',
        'testDependency1',
        'testDependency2'
      ]
      @queue = new window.DasQueue()

    it 'looks for the presence of dependencies', ->
      sinon.spy(@queue, 'enqueuedItemDependenciesLoaded')
      @queue.push(@testPush)
      expect(@queue.enqueuedItemDependenciesLoaded.called).to.be true

  describe 'when a queue already exists', ->

    beforeEach ->
      @testSpy  = sinon.spy()
      @testPush = [ @testSpy ]
      @existingQueue = new window.DasQueue()

    it 'it can receive new queue items', ->
      expect(('push' of @existingQueue)).to.be true

    it 'it processes newly pushed queue items', ->
      @existingQueue.push(@testPush)
      expect(@testSpy.called).to.be true

  describe 'when a queue is given on instantiation', ->
    it 'processes all items in the queue', ->
      spy1    = sinon.spy()
      spy2    = sinon.spy()
      subject = new window.DasQueue([
        [spy1, null],
        [spy2, null]
      ])
      expect(spy1.called).to.be true
      expect(spy2.called).to.be true

  describe 'when a dependency is undefined', ->

    beforeEach ->
      window.setTimeout = sinon.spy()
      @dependentMethod  = sinon.spy()
      @requiredLibrary  = 'requiredLibrary'
      @dependentItem    = [
        @dependentMethod,
        null,
        @requiredLibrary
      ]
      @dependentQueue = new window.DasQueue([ @dependentItem ])

    it 'pauses processing momentarilly', ->
      expect(window.setTimeout.called).to.be true

  describe 'when a dependency is available', ->

    before ->
      window.definedDependency = ->

    it 'executes and removes the enqued item', ->
      spy = sinon.spy()
      dependentQueueItem = [spy, null, 'definedDependency']
      subject = new window.DasQueue([ dependentQueueItem ])
      expect(spy.called).to.be true
      expect(subject.queue.length).to.be 0

