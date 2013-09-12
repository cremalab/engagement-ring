CollectionView = require 'views/base/collection-view'
IdeaThread = require 'models/idea_thread'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
template = require './templates/collection'

module.exports = class IdeaThreadsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  template: template
  listSelector: '.collectionItems'
  events:
    'click .add': 'newIdeaThread'
  key_bindings:
    'n': 'newIdeaThread'
  itemView: IdeaThreadView

  initialize: ->
    super
    @subscribeEvent 'save_idea_thread', @cleanup
    @subscribeEvent 'escapeForm', @cleanup

  newIdeaThread: (e) ->
    if @new_idea_thread
      new_idea_thread_view = @viewForModel(@new_idea_thread)
      new_idea_thread_view.$el.find('input:visible:first').focus()
    else
      @new_idea_thread = new IdeaThread
        user_id: Chaplin.mediator.user.get('id')
      @collection.add(@new_idea_thread, {at: 0})

  cleanup: ->
    empty_thread = @collection.find (thread) ->
      thread.get('ideas').models.length is 0
    empty_thread.dispose() if empty_thread

    @new_idea_thread = null
    @setupKeyBindings()

  initItemView: (model) ->
    new IdeaThreadView model: model, collection_view: @