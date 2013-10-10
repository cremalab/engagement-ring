CollectionView = require 'views/base/collection-view'
Comment     = require 'models/comment'
CommentView = require 'views/comments/comment_view'
template = require './templates/collection'

module.exports = class CommentsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  template: template
  listSelector: '.messages'
  itemView: CommentView
  fallbackSelector: '.empty'

  initialize: ->
    super
    @current_user = Chaplin.mediator.user
    @current_user_id = @current_user.get('id')
    @collection.fetch() if @collection.length is 0
  render: ->
    super
    @input = @$el.find('input.message-text')
    @input.on 'keydown', (e) =>
      if e.keyCode is 13
        e.preventDefault()
        e.stopPropagation()
        val = @input.val()
        @createNewMessage(val)

  createNewMessage: (val) ->
    @input.val('')
    @collection.create
      content: val
      user_id: @current_user_id
    ,
      error: =>
        @publishEvent 'error', "Your message could not be sent."
        @input.val(val)
