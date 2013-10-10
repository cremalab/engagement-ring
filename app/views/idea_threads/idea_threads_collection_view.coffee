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
  events:
    'click .add': 'newIdeaThread'
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
    @listenTo @collection, 'dispose', @cleanup
    @listenTo @collection, 'change:updated_at', (model) =>
      @filter @filterer, (view, included) ->
        unless included
          view.$el.hide()


  newIdeaThread: (e) ->
    if @new_idea_thread
      new_idea_thread_view = @viewForModel(@new_idea_thread)
      new_idea_thread_view.$el.find("input[name='title']").focus()
    else
      current_user_id = @current_user.get('id')
      ideas = new IdeasCollection()

      @new_idea_thread = new IdeaThread
        user_id: Chaplin.mediator.user.get('id')
      @new_idea_thread.set 'ideas', ideas
      @collection.add(@new_idea_thread, {at: 0})


  cleanup: (a,b,c) ->
    @new_idea_thread = null
    @setupKeyBindings()

  initItemView: (model) ->
    new IdeaThreadView model: model, collection_view: @


