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

  initialize: ->
    super
    @subscribeEvent 'save_idea_thread', @cleanup
    @subscribeEvent 'escapeForm', @cleanup
    @subscribeEvent 'notifier:update_idea_thread', @updateIdeaThread

  newIdeaThread: (e) ->
    if @new_idea_thread
      new_idea_thread_view = @viewForModel(@new_idea_thread)
      new_idea_thread_view.$el.find('input:visible:first').focus()
    else
      current_user_id = @current_user.get('id')
      ideas = new IdeasCollection()
      vote = new Vote
      idea = new Idea
        user_id: current_user_id
      idea.get('votes').add
        user_id: current_user_id
      ideas.add(idea)

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
    new IdeaThreadView model: model, collection_view: @

  updateIdeaThread: (attributes) ->
    # existing = @findWhere
    #   id: attributes.id
    # unless existing
    if attributes.deleted
      thread = @collection.findWhere
        id: attributes.id
      @collection.remove(thread) if thread
    else
      new_attr = _.clone attributes
      delete new_attr.ideas
      ideas = new IdeasCollection(attributes.ideas)
      thread = new IdeaThread(attributes)
      thread.set 'ideas', ideas
      console.log 'thread that will be added'
      console.log thread
      @collection.add thread
      # console.log 'collection'
      # console.log @collection