Model = require 'models/base/model'

module.exports = class Notifier extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    if mediator.user.get('subscription')
      secret = 'ef86e27e03206aae17f800e700fa98ff0e8ac779c1741d1dbf90d3a3d34df2b8'
      subscription = mediator.user.get('subscription')
      for_signature = "#{secret}#{subscription.channel}#{subscription.timestamp}"
      signature = new SHA1(for_signature).hexdigest()

      PrivatePub.sign
        server: mediator.streamURL('/faye')
        channel: subscription.channel
        signature: signature
        timestamp: subscription.timestamp

      PrivatePub.subscribe "/message/channel", (data, channel) =>
        data = jQuery.parseJSON(data.message)
        @notifyWeb(data)
        @notifyApp(data)

  notifyApp: (data) ->
    model_name = data.model_name
    delete data.model_name
    switch model_name
      when 'IdeaThread'
        mediator.publish 'notifier:update_idea_thread', data
      when 'Idea'
        mediator.publish 'notifier:update_idea', data
      when 'Vote'
        mediator.publish 'notifier:update_vote', data

  notifyWeb: (data) ->
    model_name = data.model_name
    delete data.model_name
    switch model_name
      when 'IdeaThread'
        notification = @createWebNotification("New Idea Thread", data.title)
        notification.show()
      # when 'Idea'
      # when 'Vote'

    notification.show() if notification

  createWebNotification: (title, content) ->
    if window.webkitNotifications.checkPermission() is 0 # 0 is PERMISSION_ALLOWED
      # function defined in step 2
      notification = window.webkitNotifications.createNotification "icon.png", title, content
      return notification
    else
      window.webkitNotifications.requestPermission()
