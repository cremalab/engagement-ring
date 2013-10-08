Controller = require 'controllers/base/controller'
Group      = require 'models/group'
Groups     = require 'collections/groups_collection'
GroupsView = require 'views/groups/groups_collection_view'

module.exports = class GroupsController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_group', @update

  update: (model) ->
    model.save model.attributes,
      success: (model, response) =>
        @publishEvent 'saved_group', model
        @publishEvent 'flash_message', "Your group #{model.get('name')} was saved"
      error: (model, response) =>
        @publishEvent 'renderError', response

  index: (params) ->
    @adjustTitle 'My Groups'
    @collection = new Groups()
    @view       = new GroupsView region: 'main', collection: @collection
    @collection.fetch()