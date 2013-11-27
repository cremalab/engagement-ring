Activity   = require 'models/activity'
Collection = require 'collections/base/collection'

module.exports = class ActivitiesCollection extends Collection
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
      @add(payload)

  applyLimit: ->
    if @size() > @limit + 1
      last = @at(@limit)
      last_id = last.get('id')
      @remove @at(@limit)

  setURL: ->
    @idea_id = @idea.get('id')
    @url = Chaplin.mediator.apiURL("/ideas/#{@idea_id}/activities")