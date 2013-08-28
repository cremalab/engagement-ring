Controller = require 'controllers/base/controller'
Idea = require 'models/idea'
Ideas = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
IdeaEditView = require 'views/ideas/idea_edit_view'

module.exports = class IdeasController extends Controller

  edit: (params) ->
    @model = new Idea
      id: params.id
    @model.fetch()

    @view = new IdeaEditView
      model: @model
      region: 'main'

  new: (params) ->
    @model = new Idea
    @model.idea_votes

  index: ->
    @collection = new Ideas
    @collection.fetch()
    @view = new IdeasCollectionView collection: @collection, region: 'main'