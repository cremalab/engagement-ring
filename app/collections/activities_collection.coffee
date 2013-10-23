Activity = require 'models/activity'

module.exports = class ActivitiesCollection extends Chaplin.Collection
  model: Activity

  initialize: (items, idea) ->
    super
    @idea = idea
    @subscribeEvent 'notifier:update_activity', @addActivity
    @listenTo @, 'add', @limit


  addActivity: (payload) ->
    if payload.recipient_type is 'Idea' and payload.recipient_id is @idea.get('id') or
    payload.trackable_type is 'Idea' and payload.trackable_id is @idea.get('id')
      @add(payload, at: 0)

  limit: ->
    if @size() > 10
      @remove @at(10)