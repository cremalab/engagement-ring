Comment = require 'models/comment'

module.exports = class CommentsCollection extends Chaplin.Collection
  model: Comment

  initialize: (items, options) ->
    super
    @idea = options.idea
    @idea_id = @idea.get('id')
    @url = Chaplin.mediator.apiURL("/ideas/#{@idea_id}/comments")
    @subscribeEvent 'notifier:update_comment', @addComment
    @listenTo @, 'add', @updateCommentCount
    @listenTo @, 'remove', @updateCommentCount

  addComment: (payload) ->
    if payload.idea_id is @idea_id
      @add(payload)

  updateCommentCount: ->
    @idea.set('comment_count', @length)