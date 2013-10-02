Controller = require 'controllers/base/controller'
UserSession = require 'models/user_session'
User = require 'models/user'
Notifier = require 'models/notifier'

module.exports = class SessionsController extends Controller


  initialize: ->
    @subscribeEvent 'login', @login
    @subscribeEvent 'set_current_user', @setCurrentUser
    @subscribeEvent 'controller_init', @getCurrentUser

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
      urlRoot: ->
        Chaplin.mediator.apiURL('/logout')
      success: =>
        @redirectTo "/"


  setCurrentUser: (user) ->
    if user is 'clear'
      Chaplin.mediator.user.clear()
      Chaplin.mediator.user.set('id', null)
      store.clear('current_user')
    else
      is_new = Chaplin.mediator.user.isNew()
      Chaplin.mediator.user = new User(user)
      store.set('current_user', user)

      if is_new
        # Send auth credentials with all subsequent requests
        @setupTokenAccess()
      else
        @publishEvent 'auth_complete'

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
    Chaplin.mediator.notifier = new Notifier()
    @publishEvent 'auth_complete'