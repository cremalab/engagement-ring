Controller = require 'controllers/base/controller'
User = require 'models/user'
ProfileEditView = require 'views/profiles/profile_edit_view'
UserEditView = require 'views/users/user_edit_view'
RegistrationView = require 'views/users/registration_view'

module.exports = class ProfilesController extends Controller
  initialize: ->
    @subscribeEvent 'save_user', @update

  index: ->

  edit: (params) ->
    if params.id
      @model = new User
        id: params.id
      @model.fetch()

    @view = new UserEditView
      model: @model
      region: 'main'

  new: (params) ->
    @model = new User()
    @view = new RegistrationView
      model: @model
      region: 'main'

  show: (params) ->
    @model = new Profile
      id: params.id
    @model.fetch()

  update: (user) ->
    @model.save
      success: ->
        @redirectTo '/'
      error: (model, response) ->
        @publishEvent 'renderError', response