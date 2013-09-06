View = require 'views/base/view'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  tagName: 'header'
  template: require './templates/header'
  listen:
    'change model': 'render'
  initialize: ->
    super
    @subscribeEvent 'auth_complete', @render
