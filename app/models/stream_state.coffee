# A simple model that stores how the RealTimeActionQueue should be executed

Model = require 'models/base/model'

module.exports = class StreamState extends Model
  defaults:
    live: true
    # Overrides other model type preferences.
    votes: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "Vote", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.
    comments: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "Comment", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.
    idea_threads: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "IdeaThread", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.
    ideas: true
    # (Boolean) If true, for each RealTimeAction with the model_name of "Idea", publish its mediator_event_name with payload immediately and then clean up the RealTimeActionQueue.

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
      live: val
      votes: val
      comments: val
      idea_threads: val
      ideas: val