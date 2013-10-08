View = require 'views/base/view'

module.exports = class AlertView extends View
  autoRender: true
  autoAttach: true
  template: require './templates/alert'
  events:
    'click .dismiss': 'dismissAlert'

  initialize: ->
    super
    @subscribeEvent 'dismissAlert', @dismissAlert

  render: ->
    super
    # Dismiss after 5 seconds
    lifespan = setTimeout =>
      @dismissAlert()
      clearTimeout(lifespan)
    , 5000

  dismissAlert: (e) ->
    e.preventDefault() if e
    @model.dispose() if @model