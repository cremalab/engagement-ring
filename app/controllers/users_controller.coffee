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
    @model = new User
      id: Chaplin.mediator.user.get('id')
    @model.fetch
      success: =>
        @adjustTitle 'Edit My Profile'
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
    user.save user.attributes,
      success: (user, response) =>
        @publishEvent 'set_current_user', response
        @redirectTo '/'
      error: (model, response) =>
        console.log $.parseJSON(response.responseText)
        @publishEvent 'renderError', response
