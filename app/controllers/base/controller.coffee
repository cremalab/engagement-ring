SiteView = require 'views/site-view'
HeaderMenu = require 'views/layout/headerMenu'

module.exports = class Controller extends Chaplin.Controller
  # Compositions persist stuff between controllers.
  # You may also persist models etc.
  initialize: ->
    super
    @current_user = Chaplin.mediator.user
    @subscribeEvent 'auth_complete', @composers
  beforeAction: (params,route) ->
    @compose 'site', SiteView
    exceptions = ['logins', 'users']
    if exceptions.indexOf(route.controller) > -1
      @composers()
    else
      Chaplin.mediator.sessions_controller.getCurrentUser()
  composers: ->
    @compose 'headerMenu', HeaderMenu, region: 'headerMenu', model: Chaplin.mediator.user