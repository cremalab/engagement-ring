View = require 'views/base/view'

module.exports = class FlashMessageView extends View
  autoRender: true
  autoAttach: true
  template: require './templates/flash_message'
  events:
    'click .dismiss': 'dismissFlash'

  initialize: ->
    super
    @subscribeEvent 'dismissFlash', @dismissFlash

  render: ->
    super
    # Dismiss after 5 seconds
    lifespan = setTimeout =>
      @dismissFlash()
      clearTimeout(lifespan)
    , 5000

  dismissFlash: (e) ->
    e.preventDefault() if e
    @model.dispose() if @model