CollectionView = require 'views/base/collection-view'
Idea = require 'models/idea'
IdeaView = require 'views/ideas/idea_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
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
    'click .ideate': 'addIdea'

  initialize: (options) ->
    super
    @thread_view = options.thread_view
    @thread_id   = @thread_view.model.get('id')
    @subscribeEvent 'saved_idea', @updateModel
    @subscribeEvent 'edit_idea', @editIdea
    @subscribeEvent 'vote', @checkVote


  addIdea: (e) ->
    e.preventDefault() if e
    idea_count = @collection.length
    idea = new Idea
      idea_thread_id: @thread_view.model.get('id')
      user_id: @current_user.get('id')
    idea.get('votes').add
      user_id: @current_user.get('id')

    @collection.add idea, {at: idea_count + 1}

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

  updateModel: (model, collection) ->
    @editing_view.dispose() if @editing_view
    @editing_view = null
    @new_idea = null
    @removeViewForItem model
    if @current_user
      user_id = @current_user.get('id')
    else
      # For tests until I find a better way
      user_id = 1
    vote = model.get('votes').findWhere
      user_id: user_id
      @checkVote(vote, model)


  resort: ->
    @collection.sort()

  checkVote: (vote, idea, votes) ->
    idea_in_collection = @collection.get(idea)
    if idea_in_collection
      old_vote = @currentUserVote()
      if old_vote
        @currentUserVotedIdea().get('votes').remove(old_vote)
      if vote
        idea.get('votes').create vote.attributes,
          wait: true
          success: =>
            @resort()
      else
        @resort()

  currentUserVote: (idea) ->
    current_idea = @currentUserVotedIdea()
    if current_idea
      votes = current_idea.get('votes')
      vote = votes.findWhere
        user_id: @current_user.get('id')
      return vote

  currentUserVotedIdea: ->
    current_voted_idea = @collection.find (idea) =>
      vote = idea.get('votes').findWhere
        user_id: @current_user.get('id')
      return true if vote
    return current_voted_idea

  removeCurrentUserVote: ->
    vote = @currentUserVote()
    vote.destroy() if vote


  checkEmpty: ->
    if @collection.size() == 0
      @thread_view.model.destroy()