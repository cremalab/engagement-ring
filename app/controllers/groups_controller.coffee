Controller = require 'controllers/base/controller'
Group      = require 'models/group'

module.exports = class GroupsController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_group', @update

  update: (model) ->
    model.save model.attributes,
      error: (model, response) =>
        @publishEvent 'renderError', response