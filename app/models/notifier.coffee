Model               = require 'models/base/model'
WebNotification     = require 'models/web_notification'
NotificationCreator = require 'lib/notification_creator'
AudioNotification   = require 'lib/audio_notification'
Bus                 = require 'lib/audio/bus'

module.exports = class Notifier extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    if "webkitAudioContext" of window
      @setupAudio()

    if mediator.user.get('subscription')
      secret = 'ef86e27e03206aae17f800e700fa98ff0e8ac779c1741d1dbf90d3a3d34df2b8'
      subscription = mediator.user.get('subscription')
      for_signature = "#{secret}#{subscription.channel}#{subscription.timestamp}"
      signature = new SHA1(for_signature).hexdigest()

      @subscribeEvent 'notifier:create', @notifyWeb

      PrivatePub.sign
        server: mediator.streamURL('/faye')
        channel: subscription.channel
        signature: signature
        timestamp: subscription.timestamp

      PrivatePub.subscribe "/message/channel", (data, channel) =>
        payload = jQuery.parseJSON(data.message)
        model_name = payload.model_name
        delete payload.model_name
        @notifyApp(model_name, payload)
        @createWebNotification(model_name, payload) if mediator.user.get('notifications')
        @createAudioNotification(model_name, payload) if "webkitAudioContext" of window


  notifyApp: (model_name, payload) ->
    switch model_name
      when 'IdeaThread'
        mediator.publish 'notifier:update_idea_thread', payload
      when 'Idea'
        mediator.publish 'notifier:update_idea', payload
      when 'Vote'
        mediator.publish 'notifier:update_vote', payload

  createWebNotification: (model_name, payload) ->
    notification = new NotificationCreator(model_name, payload)
    if notification.attributes
      @notifyWeb notification.attributes.title, notification.attributes.content

  createAudioNotification: (model_name, payload) ->
    unless payload.deleted
      unless payload.user_id is mediator.user.get('id')
        if payload.user_name
          if @accessToThread(model_name, payload)
            new AudioNotification(@stage, payload.user_name, @audio_bus)

  accessToThread: (model_name, payload) ->
      switch model_name
        when 'IdeaThread'
          thread_id = payload.id
        when 'Vote'
          thread_id = payload.thread_id
        when 'Idea'
          thread_id = payload.idea_thread_id

      access = false
      @publishEvent 'find_thread', thread_id, (thread) =>
        access = true if thread
      return access

  notifyWeb: (title, content) ->
    if title
      notification = new WebNotification
        title: title
        content: content

  setupAudio: ->
    @stage = new webkitAudioContext()
    @audio_bus = new Bus(@stage)
    @audio_bus.connect(@stage.destination)