SessionsController = require 'controllers/sessions_controller'
User = require 'models/user'

# The application object.
module.exports = class Application extends Chaplin.Application
  initialize: ->
    super

    es = new EventSource Chaplin.mediator.apiURL('/events')
    listener = (event) ->
      console.log event
      div = document.createElement("div")
      type = event.type
      div.appendChild document.createTextNode(type + ": " + ((if type is "message" then event.data else es.url)))
      document.body.appendChild div

    es.addEventListener "open", listener
    es.addEventListener "message", listener
    es.addEventListener "error", listener

  initMediator: ->
    # Create a user property
    Chaplin.mediator.user = new User()
    Chaplin.mediator.apiURL = (path) ->
      if window.location.host.indexOf('localhost') == -1
        "http://cremalab-ideas-api.herokuapp.com#{path}"
      else
        "http://localhost:9292#{path}"
    Chaplin.mediator.sessions_controller = new SessionsController()
    super
