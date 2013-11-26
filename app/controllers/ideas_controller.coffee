Controller = require 'controllers/base/controller'
Idea = require 'models/idea'
Ideas = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
IdeaEditView = require 'views/ideas/idea_edit_view'

module.exports = class IdeasController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_idea', @update

  update: (model, collection, collection_view) ->
    model.save model.attributes,
      error: (model, response) =>
        @publishEvent 'renderError', response