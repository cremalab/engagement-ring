Controller = require 'controllers/base/controller'
Idea = require 'models/idea'
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