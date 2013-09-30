CollectionView = require 'views/base/collection-view'
Idea = require 'models/idea'
IdeaView = require 'views/ideas/idea_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
Vote = require 'models/vote'
VotesCollection = require 'collections/votes_collection'
template = require './templates/collection'

module.exports = class IdeasCollectionView extends CollectionView

  template: template
  listSelector: '.collectionItems'
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  key_bindings:
    'esc': 'escapeForm'
  events:
    'click .ideate': 'newIdea'

  initialize: (options) ->
    super
    @thread_view = options.thread_view
    @thread_id   = @thread_view.model.get('id')
    @subscribeEvent 'saved_idea', @updateModel
    @subscribeEvent 'notifier:update_idea', @addIdea
    @subscribeEvent 'notifier:update_vote', @updateVote
    @subscribeEvent 'reset_top_level_keys', @setupKeyBindings
    @subscribeEvent 'escapeForm', @checkEmpty


  newIdea: (e) ->
    e.preventDefault() if e
    idea_count = @collection.length
    idea = new Idea
      idea_thread_id: @thread_view.model.get('id')
      user_id: @current_user.get('id')
    idea.get('votes').add
      user_id: @current_user.get('id')

    @collection.add idea, {at: idea_count + 1}

  addIdea: (data) ->
    if data.deleted
      idea = @collection.findWhere
        id: data.id
      @collection.remove(idea) if idea
    else
      if @thread_id is data.idea_thread_id
        existing = @collection.findWhere
          id: data.id
        if existing
          data = _.pick(data, ['title', 'description', 'when'])
          existing.set data
          @updateModel existing, @collection
        else
          idea = new Idea(data)
          @collection.add idea
          @updateModel idea, @collection

  editIdea: (model) ->
    @removeViewForItem(model)
    model.set 'edited', true
    @editing_view = new IdeaEditView model: model, collection_view: @

    @insertView(model, @editing_view)
    @new_idea = model

  escapeForm: (idea) ->
    if idea
      idea.unset('edited')
      if idea.isNew()
        @collection.remove(idea)
        @new_idea = null
      else
        @updateModel(idea)
    else
      @collection.remove(@new_idea)
      @new_idea = null
      @publishEvent 'escapeForm'

  initItemView: (model) ->
    if model.isNew()
      view = new IdeaEditView model: model, collection_view: @
      @editing_view = view
      @new_idea = model
    else
      @new_idea = null
      view = new IdeaView model: model, collection_view: @, autoRender: true
    view

  save: (model) ->
    @editing_view.dispose() if @editing_view
    @editing_view = null
    if @thread_view.model.isNew()
      @thread_view.save()
    else
      @publishEvent 'save_idea', model, @collection, @
      @collection.remove(model)

  updateModel: (model, collection) ->
    @editing_view.dispose() if @editing_view
    @editing_view = null
    @new_idea = null
    user_id = model.get 'user_id'
    vote = model.get('votes').findWhere
      user_id: user_id

    if collection
      model_in_collection = collection.find(model)
      model_in_collection.set(model.attributes)

    @checkVote(vote, model, false) if vote


  updateVote: (data) ->
    unless data.deleted
      idea = @collection.findWhere
        id: data.idea_id
      if idea
        votes = idea.get('votes')
        vote = new Vote(data)
        @checkVote(vote, idea, true)

  resort: ->
    @collection.sort()

  checkVote: (vote, idea, remote) ->
    idea_in_collection = @collection.get(idea)
    user_id = vote.get('user_id')
    if idea_in_collection and @thread_view.model and @thread_view.model.userCanVote(@current_user.id)
      old_vote = @currentUserVote(user_id)
      if old_vote
        @currentUserVotedIdea(user_id).get('votes').remove(old_vote)
      if vote
        if remote
          idea.get('votes').add vote
          @resort()
        else
          idea.get('votes').create vote.attributes
      else
        @resort()


  currentUserVote: (user_id) ->
    current_idea = @currentUserVotedIdea(user_id)

    if current_idea
      votes = current_idea.get('votes')
      vote = votes.findWhere
        user_id: user_id
      return vote

  currentUserVotedIdea: (user_id) ->
    current_voted_idea = @collection.find (idea) =>
      vote = idea.get('votes').findWhere
        user_id: user_id
      return true if vote

    return current_voted_idea


  checkEmpty: ->
    if @collection.size() == 0
      if @thread_view.model
        if @thread_view.model.isNew()
          @thread_view.model.dispose()
        else
          @thread_view.model.destroy()
