View = require 'views/base/view'
CurrentUserInfoView = require 'views/layout/current_user_info_view'

module.exports = class HeaderMenu extends View
  autoRender: true
  template: require './templates/headerMenu'
  listen:
    'change model': 'render'
  initialize: ->
    super
    @subscribeEvent 'auth_complete', @render

  render: ->
    super
    current_user_view = new CurrentUserInfoView
      model: Chaplin.mediator.user
      container: @$el
      autoRender: true