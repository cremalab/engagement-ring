Model = require 'models/base/model'

module.exports = class WebNotification extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    @createWebNotification()

  createWebNotification: (title, content) ->
    if window.webkitNotifications.checkPermission() is 0 # 0 is PERMISSION_ALLOWED
      # function defined in step 2
      @notification = window.webkitNotifications.createNotification "icon.png", @get('title'), @get('content')
      if @notification
        @notification.show()
        return @notification
    else
      window.webkitNotifications.requestPermission()

  dispose: ->
    @notification.cancel()
    super
