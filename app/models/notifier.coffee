Model = require 'models/base/model'

module.exports = class Notifier extends Model

  initialize: ->
    super
    es = new EventSource Chaplin.mediator.apiURL('/events')
    listener = (event) =>
      @notify(event)

    es.addEventListener "open", listener
    es.addEventListener "message", listener
    es.addEventListener "error", listener

  notify: (event) ->
    console.log 'NOOOOOTIFY'
    switch event.model
      when 'Idea'
        mediator.publish 'notifier:update_idea', event.data
      when 'Vote'
        mediator.publish 'notifier:update_vote', event.data