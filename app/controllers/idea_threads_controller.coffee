Controller = require 'controllers/base/controller'
IdeaThread = require 'models/idea_thread'
IdeaThreads = require 'collections/idea_threads_collection'
IdeaThreadsCollectionView = require 'views/idea_threads/idea_threads_collection_view'
IdeaEditView = require 'views/ideas/idea_edit_view'

module.exports = class IdeaThreadsController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_idea', @update

  edit: (params) ->
    @model = new Idea
      id: params.id
    @model.fetch()

    @view = new IdeaEditView
      model: @model
      region: 'main'

  index: ->
    @collection = new IdeaThreads()
    @collection.fetch()
    @view = new IdeaThreadsCollectionView collection: @collection, region: 'main'

  update: (model) ->
    model.save model.attributes,
      success: (model) =>
        @publishEvent 'saved_idea', model
      error: (model, response) =>
        console.log $.parseJSON(response.responseText)
        @publishEvent 'renderError', response
