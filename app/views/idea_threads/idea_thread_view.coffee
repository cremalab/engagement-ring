View = require 'views/base/view'
VotesCollection = require 'collections/votes_collection'
IdeasCollection = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'

module.exports = class IdeaThreadView extends View
  template: require './templates/show'
  className: 'ideaThread'
  regions:
    ideas: '.ideas'
  textBindings: true
  listen:
    "change collection": "setOriginal"

  initialize: ->
    super
    @ideas = @model.get('ideas')
    @setOriginal()

  setOriginal: ->
    @original_idea = @ideas.findWhere
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
    @publishEvent 'save_idea_thread', @model, @ideas