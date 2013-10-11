CollectionView = require 'views/base/collection-view'
IdeaThread = require 'models/idea_thread'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
IdeasCollection = require 'collections/ideas_collection'
VotesCollection = require 'collections/votes_collection'
Vote = require 'models/vote'
Idea = require 'models/idea'
template = require './templates/collection'

module.exports = class IdeaThreadsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  template: template
  listSelector: '.collectionItems'
  key_bindings:
    'n': 'newIdeaThread'
  filterer: (item, index) ->
    if item.get('status') is 'archived'
      return false
    else
      return true

  initialize: ->
    super
    @subscribeEvent 'save_idea_thread', @cleanup
    @subscribeEvent 'escapeForm', @cleanup
    @subscribeEvent 'reset_top_level_keys', @setupKeyBindings
    @subscribeEvent 'add_new_idea_thread', @newIdeaThread

  newIdeaThread: (e) ->
    if @new_idea_thread
      new_idea_thread_view = @viewForModel(@new_idea_thread)
      @$el.find("input[name='title']").focus()
    else
      current_user_id = @current_user.get('id')
      ideas = new IdeasCollection()

      @new_idea_thread = new IdeaThread
        user_id: Chaplin.mediator.user.get('id')
      @new_idea_thread.set 'ideas', ideas
      @collection.add(@new_idea_thread, {at: 0})


  cleanup: ->
    empty_thread = @collection.find (thread) ->
      thread.get('ideas').models.length is 0
    empty_thread.dispose() if empty_thread

    @new_idea_thread = null
    @setupKeyBindings()

  initItemView: (model) ->
    if model.isNew()
      new IdeaThreadView model: model, collection_view: @
    else
      new IdeaThreadView model: model, collection_view: @


