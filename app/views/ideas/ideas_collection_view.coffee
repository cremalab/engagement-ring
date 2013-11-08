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
    @subscribeEvent 'reset_top_level_keys', @setupKeyBindings
    @listenTo @collection, 'change:edited', @handleEdit

  render: ->
    super
    unless @thread_view.model.isVotable()
      @$el.find(".ideate").remove()

  newIdea: (e) ->
    e.preventDefault() if e
    idea_count = @collection.length
    idea = new Idea
      idea_thread_id: @thread_view.model.get('id')
      user_id: @current_user.get('id')
    idea.get('votes').add
      user_id: @current_user.get('id')

    @collection.add idea, {at: idea_count + 1}

  handleEdit: (model, edited) ->
    if edited
      @reRender(model)
    else
      @escapeForm(model)

  reRender: (model) ->
    @removeViewForItem(model)
    view = @initItemView(model)
    @insertView(model, view)

  escapeForm: (idea) ->
    @thread_view.$el.removeClass('syncing') if @thread_view.$el
    @new_idea = null

    if idea
      @removeViewForItem(idea)
      if idea.isNew()
        @collection.remove(idea)
        @new_idea = null
      else
        idea.unset('edited')

    else
      @collection.remove(@new_idea)
      @new_idea = null

    @editing_view.dispose() if @editing_view
    @editing_view = null

    @resort()

  initItemView: (model) ->
    if model.isNew() or model.get('edited')
      view = new IdeaEditView
        model: model
        collection_view: @
        autoRender: true
        autoAttach: true
      @editing_view = view
      @new_idea = model
    else
      @new_idea = null
      view = new IdeaView model: model, collection_view: @, autoRender: true
    view

  save: (model) ->
    @thread_view.$el.addClass('syncing')
    model.save model.attributes,
      success: =>
        @renderItem(model)

  resort: ->
    @collection.sort()
