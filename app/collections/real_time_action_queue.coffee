# All Notifier events are first passed through the RealTimeActionQueue
# and remain there until runRealTimeActions event is published.

Collection = require 'collections/base/collection'

module.exports = class RealTimeActionQueue extends Collection
  listen:
    'real_time_events:continue': 'fireActions'
  fireActions: ->
    @each (action) ->
      action.fire()

  cleanup: ->
    @reset()