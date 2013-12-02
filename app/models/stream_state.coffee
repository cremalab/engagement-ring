# A simple model that stores how the RealTimeActionQueue should be executed

Model = require 'models/base/model'

module.exports = class StreamState extends Model
  defaults:
    Vote: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "Vote", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.
    Comment: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "Comment", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.
    IdeaThread: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "IdeaThread", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.
    Idea: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "Idea", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.
    Activity: true

  initialize: ->
    super
    @subscribeEvent 'action_queue:continue', =>
      @setAll(true)
    @subscribeEvent 'action_queue:pause', =>
      @setAll(false)

  setAll: (val) ->
    if typeof val isnt "boolean"
      throw new Error "StreamState values must be true or false"
    @set
      Vote: val
      Comment: val
      IdeaThread: val
      Idea: val
      Activity: val