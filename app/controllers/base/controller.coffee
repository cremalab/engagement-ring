SiteView = require 'views/site-view'
HeaderView = require 'views/layout/header_view'

module.exports = class Controller extends Chaplin.Controller
  # Compositions persist stuff between controllers.
  # You may also persist models etc.
  beforeAction: ->
    @compose 'site', SiteView
    @compose 'header', HeaderView, region: 'header'
