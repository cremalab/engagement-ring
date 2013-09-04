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

  initialize: ->
    super
    @model_ideas = @model.get('ideas')


  render: ->
    super
    @ideas_view = new IdeasCollectionView
      collection: @model_ideas
      region: 'ideas'
      thread_view: @

  save: ->
    @publishEvent 'save_idea_thread', @model, @model_ideas