Activity = require 'models/activity'
Comment  = require 'models/comment'

module.exports = class ActivityFeed extends Chaplin.Collection
  model: (attrs, options) ->
    switch attrs.model_name
      when "Activity"
        new Activity(attrs)
      else
        new Comment(attrs)

  comparator: (item) ->
    return item.get("created_at")

  initialize: (items, idea) ->
    super
    @idea  = idea
    @subscribeEvent 'notifier:update_activity', @addActivity
    @subscribeEvent 'notifier:update_comment', @addComment
    @setURL()

  addActivity: (payload) ->
    unless payload.trackable_type is 'Comment'
      if payload.recipient_type is 'Idea' and payload.recipient_id is @idea.get('id') or
      payload.trackable_type is 'Idea' and payload.trackable_id is @idea.get('id')
        @add(payload)

  addComment: (payload) ->
    if payload.idea_id is @idea_id
      @idea.get('comments').add(payload)
      @add(payload)

  setURL: ->
    @idea_id = @idea.get('id')
    @url = Chaplin.mediator.apiURL("/ideas/#{@idea_id}/activities")