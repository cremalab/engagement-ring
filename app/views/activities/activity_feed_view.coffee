CollectionView = require 'views/base/collection-view'
Activity     = require 'models/activity'
ActivityView = require 'views/activities/activity_view'
Comments     = require 'collections/comments_collection'
CommentView  = require 'views/comments/comment_view'
template     = require './templates/feed'

module.exports = class ActivityFeedView extends CollectionView

  template: template
  listSelector: '.feed'

  initialize: ->
    super
    @idea_id = @collection.idea.get('id')
    @collection.fetch
      success: =>
        comments  = @collection.where
          model_name: 'Comment'
        @comments = new Comments(comments, {idea_id: @idea_id})

  render: ->
    super
    @input = @$el.find('input.message-text')
    @input.on 'keydown', (e) =>
      if e.keyCode is 13
        e.preventDefault()
        e.stopPropagation()
        val = @input.val()
        @createNewMessage(val)

  viewAll: (e) ->
    e.preventDefault()

  initItemView: (model) ->
    if model.get('model_name') is 'Comment'
      new CommentView model: model
    else
      new ActivityView
        model: model
        full_view: true

  createNewMessage: (val) ->
    @input.val('')
    @collection.add
      content: val
      user_id: Chaplin.mediator.user.get('id')
      model_name: 'Comment'
      created_at: moment()
    @comments.create
      content: val
      user_id: Chaplin.mediator.user.get('id')
    ,
      error: =>
        @publishEvent 'error', "Your message could not be sent."
        @input.val(val)
