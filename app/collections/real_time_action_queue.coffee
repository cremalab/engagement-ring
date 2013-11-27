# All Notifier events are first passed through the RealTimeActionQueue
# and remain there until runRealTimeActions event is published.

Collection     = require 'collections/base/collection'
RealTimeAction = require 'models/real_time_action'

module.exports = class RealTimeActionQueue extends Collection
  model: RealTimeAction

  initialize: ->
    super
    @stream_state = Chaplin.mediator.stream_state
    @listenTo @, 'add', @fireAction
    @listenTo @, 'change:published', @cleanup
    @listenTo @stream_state, 'change', @fireAllActions

  fireAction: (action) ->
    if @stream_state.get('live') is true
      action.fire()

  fireAllActions: ->
    @each (action) =>
      @fireAction(action)

  cleanup: ->
    pending = @where({published: false})
    unless pending.length > 0
      @reset()