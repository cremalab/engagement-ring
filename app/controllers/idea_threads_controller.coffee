Controller = require 'controllers/base/controller'
Idea = require 'models/idea'
IdeaThread = require 'models/idea_thread'
IdeaThreads = require 'collections/idea_threads_collection'
IdeaThreadsCollectionView = require 'views/idea_threads/idea_threads_collection_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
ActionButtonView = require 'views/layout/action_button_view'

module.exports = class IdeaThreadsController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_idea', @update
    @subscribeEvent 'save_idea_thread', @update

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
    action_view = new ActionButtonView
      region: 'headerAction'
      action_type: 'new_thread'

    @adjustTitle('Dashboard')

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
