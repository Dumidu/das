class QueueItem
  constructor: (item) ->
    if typeof Object.prototype.toString.call(item) is not '[object Array]'
      throw "QueueItem requires an Array"

    @method       = ->
    @event        = null
    @dependencies = []

    @create(item)

  create: (item) ->
    @method       = item.shift()
    @event        = item.shift() unless !item.length
    @dependencies = item         unless !item.length


class Queue
  QueueItemFactory: QueueItem

  constructor: (rawQueue) ->
    @queue        = []
    @history      = []
    @enqueuedItem = null
    @queueTimeout = null

    @enqueueRawItems(rawQueue) unless !rawQueue

    @processQueue() if @queue.length

  push: (rawItem) ->
    if typeof Object.prototype.toString.call(rawItem) is not '[object Array]'
      throw "Queue.push() requires an Array"
    @enqueueRawItem(rawItem)
    @processQueue()

  enqueueRawItems: (rawQueue) ->
    for rawItem in rawQueue
      @enqueueRawItem(rawItem)

  enqueueRawItem: (rawItem) ->
    queueItem = new @QueueItemFactory(rawItem)
    @enqueueItem(queueItem)

  enqueueItem: (queueItem) ->
    @queue.push(queueItem)

  processQueue: () ->
    @updateEnqueuedItem()

    if (@enqueuedItemDependenciesLoaded())
      @executeEnqueued()
      @clearEnqueued()
      @processQueue() if @queue.length
    else
      @queueTimeout = window.setTimeout(@processQueue, 50)

  enqueuedItemDependenciesLoaded: ->
    return true unless @enqueuedItem.dependencies.length
    for method in @enqueuedItem.dependencies
      return false unless @methodIsLoaded(method)
    return true

  updateEnqueuedItem: ->
    @enqueuedItem ?= @shiftTopOfQueue()

  shiftTopOfQueue: ->
    @queue.shift()

  methodIsLoaded: (method) ->
    return true if (method of window)
    return false

  executeEnqueued: ->
    @enqueuedItem.method()

  clearEnqueued: ->
    @history.push(@enqueuedItem)
    @enqueuedItem = null

module?.exports = Queue
