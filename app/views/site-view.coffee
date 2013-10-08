View      = require 'views/base/view'
FlashMessage     = require 'models/flash_message'
FlashMessageView = require 'views/layout/flash_message_view'

# Site view is a top-level view which is bound to body.
module.exports = class SiteView extends View
  container: 'body'
  id: 'site-container'
  regions:
    header: '#header-container'
    main: '#page-container'
    user_info: '#user_info'
    flash_messages: '#flash_messages'
  template: require 'views/layout/templates/site'

  initialize: ->
    super
    @subscribeEvent 'flash_message', @renderFlash
    @subscribeEvent 'clear_flash_message', @clearFlash

  renderFlash: (message) ->
    @publishEvent 'dismissAlert'
    @flashMessage  = new FlashMessage(message: message)
    @flashMessageView = new FlashMessageView(model: @flashMessage, region: 'flash_messages')
  clearFlash: ->
    @flashMessage.dispose() if @flashMessage