Activity = require 'models/activity'
Comment  = require 'models/comment'
ActivitiesCollection = require 'collections/activities_collection'

module.exports = class ActivityFeed extends ActivitiesCollection
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
    @subscribeEvent 'notifier:update_comment', @addComment

  addActivity: (payload) ->
    unless payload.trackable_type is 'Comment'
      super

  addComment: (payload) ->
    if payload.idea_id is @idea_id
      @idea.get('comments').add(payload)
      @add(payload)