Model = require 'models/base/model'

module.exports = class Notifier extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    PrivatePub.sign
      server: "http://localhost:9292/faye"
      channel: "message/channel"

    PrivatePub.subscribe "http://localhost:9292/faye", (data, channel) ->
      console.log "PRIVATE"
      console.log data
      console.log channel

  notify: (event) ->
    data = jQuery.parseJSON(event.data)
    model_name = data.model_name
    delete data.model_name
    switch model_name
      when 'IdeaThread'
        mediator.publish 'notifier:update_idea_thread', data
      when 'Idea'
        mediator.publish 'notifier:update_idea', data
      when 'Vote'
        mediator.publish 'notifier:update_vote', data