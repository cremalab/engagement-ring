View      = require 'views/base/view'
Alert     = require 'models/alert'
AlertView = require 'views/layout/alert_view'

# Site view is a top-level view which is bound to body.
module.exports = class SiteView extends View
  container: 'body'
  id: 'site-container'
  regions:
    header: '#header-container'
    main: '#page-container'
    user_info: '#user_info'
    alerts: '#alerts'
  template: require 'views/layout/templates/site'

  initialize: ->
    super
    @subscribeEvent 'alert', @renderAlert
    @subscribeEvent 'clear_alerts', @clearAlerts

  renderAlert: (message) ->
    @publishEvent 'dismissAlert'
    @alert  = new Alert(message: message)
    @alertView = new AlertView(model: @alert, region: 'alerts')
    console.log @alertView.$el
  clearAlerts: ->
    @alert.dispose() if @alert