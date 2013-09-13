View = require 'views/base/view'
VotesCollection = require 'collections/votes_collection'
IdeasCollection = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
IdeaThread = require 'models/idea_thread'

module.exports = class IdeaThreadView extends View
  template: require './templates/show'
  className: 'ideaThread'
  regions:
    ideas: '.ideas'
  textBindings: true
  listen:
    "change collection": "setOriginal"

  initialize: (options) ->
    super
    @collection_view = options.collection_view
    @ideas = @model.get('ideas')
    @setOriginal()

  setOriginal: ->
    @original_idea = @model.get('ideas').findWhere
      id: @model.get('original_idea_id')
    @original_idea.set 'original', true

  render: ->
    super
    @ideas_view = new IdeasCollectionView
      collection: @ideas
      region: 'ideas'
      thread_view: @
      original_idea: @original_idea

  save: ->
    attrs = _.clone @model.attributes
    @publishEvent 'save_idea_thread', @model, @ideas, @collection_view, attrs
    @dispose()