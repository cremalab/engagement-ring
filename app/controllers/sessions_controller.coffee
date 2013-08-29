Controller = require 'controllers/base/controller'
LoginView = require 'views/sessions/session_edit_view'
UserSession = require 'models/user_session'

module.exports = class SessionsController extends Controller

  initialize: ->
    console.log 'SESSIONS CONTROLLER'
    @subscribeEvent 'login', @login
    @subscribeEvent 'set_current_user', @setCurrentUser
    @subscribeEvent 'controller_init', @getCurrentUser

  new: ->
    @model = new UserSession()
    @view = new LoginView model: @model, region: 'main'

  login: (session_creds) ->
    session_creds.save session_creds.attributes,
      success: (user, resp) =>
        @setCurrentUser resp
        @redirectTo '/'
      error: (session, resp) =>
        @publishEvent 'renderError', resp

  setCurrentUser: (user) ->
    Chaplin.mediator.user.set(user)

  getCurrentUser: ->
    $.get 'http://localhost:3000/me', (response) ->
      console.log response
