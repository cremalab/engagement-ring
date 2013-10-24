Activity = require 'models/activity'

module.exports = class ActivitiesCollection extends Chaplin.Collection
  model: Activity

  initialize: (items, idea, limit) ->
    super
    @idea  = idea
    @limit = limit
    @subscribeEvent 'notifier:update_activity', @addActivity
    @listenTo @, 'add', @applyLimit
    @setURL()

  addActivity: (payload) ->
    if payload.recipient_type is 'Idea' and payload.recipient_id is @idea.get('id') or
    payload.trackable_type is 'Idea' and payload.trackable_id is @idea.get('id')
      @add(payload, at: 0)

  applyLimit: ->
    if @limit
      if @size() > 10
        @remove @at(10)

  setURL: ->
    @idea_id = @idea.get('id')
    @url = Chaplin.mediator.apiURL("/ideas/#{@idea_id}/activities")