SiteView = require 'views/site-view'
HeaderView = require 'views/layout/header_view'
CurrentUserInfoView = require 'views/layout/current_user_info_view'

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
    @compose 'header', HeaderView, region: 'header', model: Chaplin.mediator.user
    @compose 'user-info', CurrentUserInfoView, region: 'user_info', model: Chaplin.mediator.user
