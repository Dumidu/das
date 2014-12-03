describe 'Feature: Async Library Queue', ->

  before ->
    @Stubs = require '../stubs/stubs'

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

    it 'pauses processing momentarilly', ->
      window.setTimeout = sinon.spy()
      dependentMethod = ->
      dependentPush = [
        dependentMethod,
        'foo',
        'undefinedDependency1',
        'undefinedDependency2'
      ]
      dependentQueue = new window.DasQueue([dependentPush])
      expect(window.setTimeout.called).to.be true

    it 'executes the Queue Item once the dependency is defined', ->
      #expect(true).to.be false

  describe 'when a dependency is available', ->

    before ->
      window.definedDependency = ->

    it 'executes and removes the enqued item', ->
      spy = sinon.spy()
      dependentQueueItem = [spy, null, 'definedDependency']
      subject = new window.DasQueue([ dependentQueueItem ])
      console.log("\nsubject.queue.length:")
      console.log(subject.queue.length)
      expect(spy.called).to.be true
      expect(subject.queue.length).to.be 0

