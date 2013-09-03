Controller = require 'controllers/base/controller'
LoginView = require 'views/sessions/session_edit_view'
UserSession = require 'models/user_session'

module.exports = class SessionsController extends Controller


  initialize: ->
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

  logout: ->
    @setCurrentUser('clear')
    $.ajax
      type: 'GET'
      url: 'http://localhost:3000/logout'
      success: =>
        @redirectTo "/"


  setCurrentUser: (user) ->
    if user is 'clear'
      Chaplin.mediator.user.clear()
      Chaplin.mediator.user.set('logged_in', false)
      console.log Chaplin.mediator.user
    else
      Chaplin.mediator.user.set(user)

    store.set('current_user', Chaplin.mediator.user)
    # Send auth credentials with all subsequent requests
    @setupTokenAccess()

  getCurrentUser: ->
    # Check if a user exists in the mediator or localstorage:
    mediator_user = Chaplin.mediator.user
    stored_user = store.get('current_user')

    if mediator_user and mediator_user.get('auth') and
    mediator_user.get('auth').access_token
      user = Chaplin.mediator.user.attributes
    else if stored_user and stored_user.auth and stored_user.auth.access_token
      user = stored_user
    else
      user = false

    # if so, use those credentials to make sure access_token is good
    if user
      @setCurrentUser(user)
    else
      @handleUnauthorized()

  handleUnauthorized: ->
    @redirectTo '/login'

  setupTokenAccess: ->
    if Chaplin.mediator.user.get('auth')
      auth = Chaplin.mediator.user.get('auth')
      auth = Chaplin.mediator.user.get('auth')

      $.ajaxSetup
        beforeSend: (xhr) ->
          dataType: 'json'
          xhr.setRequestHeader('X-Requested-With', xhr)
          xhr.setRequestHeader('X-User-ID', auth.user_id)
          xhr.setRequestHeader('X-Access-Token', auth.access_token)
    else
      @handleUnauthorized()