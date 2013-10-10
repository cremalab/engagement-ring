Comment = require 'models/comment'

module.exports = class CommentsCollection extends Chaplin.Collection
  model: Comment

  initialize: (items, options) ->
    super
    @idea_id = options.idea_id
    @url = Chaplin.mediator.apiURL("/ideas/#{@idea_id}/comments")
    @subscribeEvent 'notifier:update_comment', @addComment

  addComment: (payload) ->
    if payload.idea_id is @idea_id
      @add(payload)