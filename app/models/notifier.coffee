Model = require 'models/base/model'

module.exports = class Notifier extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    es = new EventSource Chaplin.mediator.apiURL('/events')
    listener = (event) =>
      @notify(event)

    es.addEventListener "open", listener
    es.addEventListener "message", listener
    es.addEventListener "error", listener

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