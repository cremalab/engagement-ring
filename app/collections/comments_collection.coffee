Comment = require 'models/comment'

module.exports = class CommentsCollection extends Chaplin.Collection
  model: Comment

  initialize: (items, options) ->
    super
    @idea = options.idea

    # If this isn't a new idea, set up the
    # comments collection correctly
    @updateIdea() if @idea.get('id')
    @listenTo @idea, 'change:id', @updateIdea

    # Listen for comment events from PrivatePub
    @subscribeEvent 'notifier:update_comment', @addComment

    # Keep track of the current comment count in the idea model
    @listenTo @, 'add', @updateCommentCount
    @listenTo @, 'remove', @updateCommentCount

  updateIdea: ->
    @idea_id = @idea.get('id')

    # Construct a nested route from the related Idea ID
    @url = Chaplin.mediator.apiURL("/ideas/#{@idea_id}/comments")

    # Since the comments aren't passed with the JSON (so it doesn't
    # end up being huge), populate the collection with blank models
    # so the comment count is accurate.
    if @length != @idea.get('comment_count')
      for [0...@idea.get('comment_count')]
        @add({})

  addComment: (payload) ->
    # If the comment belongs to this idea, add it
    if payload.idea_id is @idea_id
      @add(payload)

  updateCommentCount: ->
    # Update the idea model with the current comment count
    @idea.set('comment_count', @length)