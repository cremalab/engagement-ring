SiteView = require 'views/site-view'
HeaderView = require 'views/layout/header_view'
CurrentUserInfoView = require 'views/layout/current_user_info_view'

module.exports = class Controller extends Chaplin.Controller
  # Compositions persist stuff between controllers.
  # You may also persist models etc.
  initialize: ->
    super
    @current_user = Chaplin.mediator.user
  beforeAction: (params,route) ->
    @compose 'site', SiteView
    @compose 'header', HeaderView, region: 'header', model: Chaplin.mediator.user
    @compose 'user-info', CurrentUserInfoView, region: 'header', model: Chaplin.mediator.user
    exceptions = ['sessions', 'users']
    unless exceptions.indexOf(route.controller) > -1
      Chaplin.mediator.sessions_controller.getCurrentUser()