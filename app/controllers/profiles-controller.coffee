Controller = require 'controllers/base/controller'
Profile = require 'models/profile'
ProfileEditView = require 'views/profiles/profile_edit_view'

module.exports = class ProfilesController extends Controller
  index: ->

  edit: (params) ->
    if params.id
      @model = new Profile
        id: params.id
      @model.fetch()
    else
      @model = new Profile()

    @view = new ProfileEditView
      model: @model
      region: 'main'

  show: (params) ->
    @model = new Profile
      id: params.id
    @model.fetch()