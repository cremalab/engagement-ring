Controller = require 'controllers/base/controller'
Idea = require 'models/idea'
IdeaThread = require 'models/idea_thread'
IdeaThreads = require 'collections/idea_threads_collection'
IdeaThreadsCollectionView = require 'views/idea_threads/idea_threads_collection_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'

module.exports = class IdeaThreadsController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_idea', @update
    @subscribeEvent 'save_idea_thread', @update


  index: ->
    @collection = new IdeaThreads()
    @collection.fetch()
    @view = new IdeaThreadsCollectionView collection: @collection, region: 'main'
    @adjustTitle('Dashboard')

  archive: ->
    @collection = new IdeaThreads()
    @collection.url = Chaplin.mediator.apiURL('/idea_threads/archives')
    @collection.fetch()
    @view = new IdeaThreadsCollectionView collection: @collection, region: 'main', archives: true
    @adjustTitle('Archive')

  show: (params) ->
    @model = new IdeaThread
      id: params.id
    @model.fetch
      success: =>
        @view = new IdeaThreadView model: @model, region: 'main', autoRender: true
        @adjustTitle @model.get('title')

  update: (model) ->
    model.save model.attributes,
      error: (model, response) =>
        console.log $.parseJSON(response.responseText)
        @publishEvent 'renderError', response
