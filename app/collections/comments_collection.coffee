Comment = require 'models/comment'

module.exports = class CommentsCollection extends Chaplin.Collection
  model: Comment

  comparator: (a,b) ->
    a_time = a.get('created_at')
    b_time = b.get('created_at')
    if moment(a_time).isBefore(b_time)
      return -1
    else
      return 1

  initialize: (items, options) ->
    super
    @idea_id = options.idea_id
    @url = Chaplin.mediator.apiURL("/ideas/#{@idea_id}/comments")
    @subscribeEvent 'notifier:update_comment', @addComment

  addComment: (payload) ->
    if payload.idea_id is @idea_id
      @add(payload)