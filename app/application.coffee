SessionsController = require 'controllers/sessions_controller'
User = require 'models/user'

# The application object.
module.exports = class Application extends Chaplin.Application
  initialize: ->
    super
    @initControllers()
  initMediator: ->
    # Create a user property
    Chaplin.mediator.user = new User()
    super
  initControllers: ->
    new SessionsController()
    @publishEvent 'controller_init'