SessionsController = require 'controllers/sessions_controller'
User = require 'models/user'

# The application object.
module.exports = class Application extends Chaplin.Application
  initialize: ->
    super
  initMediator: ->
    # Create a user property
    Chaplin.mediator.user = new User()
    Chaplin.mediator.sessions_controller = new SessionsController()
    super
