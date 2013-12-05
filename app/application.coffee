SessionsController  = require 'controllers/sessions_controller'
GroupsController    = require 'controllers/groups_controller'
RealTimeActionQueue = require 'collections/real_time_action_queue'
StreamState         = require 'models/stream_state'
User = require 'models/user'

# The application object.
module.exports = class Application extends Chaplin.Application
  initMediator: ->
    # Create a user property
    Chaplin.mediator.user = new User()
    Chaplin.mediator.apiURL = (path) ->
      if window.location.host.indexOf('localhost') == -1
        "ec2-54-237-101-117.compute-1.amazonaws.com#{path}"
      else
        "http://localhost:3000#{path}"
    Chaplin.mediator.streamURL = (path) ->
      if window.location.host.indexOf('localhost') == -1
        "http://ec2-174-129-178-97.compute-1.amazonaws.com#{path}"
      else
        "http://localhost:9292#{path}"
    Chaplin.mediator.stream_state           = new StreamState()
    Chaplin.mediator.real_time_action_queue = new RealTimeActionQueue()
    Chaplin.mediator.sessions_controller    = new SessionsController()
    Chaplin.mediator.groups_controller      = new GroupsController()
    super