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
    # @ideas = new IdeasCollection @model.get('ideas')
    @ideas = @model.get('ideas')
    if @model.isNew()
      current_user_id = Chaplin.mediator.user.get('id')
      console.log @ideas
      votes = new VotesCollection()
      votes.add
        user_id: current_user_id
      @ideas.add
        user_id: current_user_id
        votes: votes


  render: ->
    super
    @ideas_view = new IdeasCollectionView
      collection: @ideas
      region: 'ideas'
      thread_view: @

  save: ->
    console.log @model
    @model.save @model.attributes,
      success: (res) =>
        console.log res