Model               = require 'models/base/model'
WebNotification     = require 'models/web_notification'
NotificationCreator = require 'lib/notification_creator'
AudioNotification   = require 'lib/audio_notification'
Bus                 = require 'lib/audio/bus'


module.exports = class Notifier extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    @action_queue = Chaplin.mediator.real_time_action_queue
    if "webkitAudioContext" of window
      @setupAudio()
    if mediator.user.get('subscription')
      @subscribeEvent 'notifier:create', @notifyWeb
      @setupPrivatePubListeners()

  setupPrivatePubListeners: ->
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
      payload = jQuery.parseJSON(data.message)
      model_name = payload.model_name
      unless payload.user_id is Chaplin.mediator.user.get('id')
        # Unless this model was created by the current user
        @notifyApp(model_name, payload)
        @createWebNotification(model_name, payload) if mediator.user.get('notifications')
        if "webkitAudioContext" of window and mediator.user.get('notification_setting').get('sound')
          @createAudioNotification(model_name, payload)
        else
      else if model_name is 'Activity'
        # Activities are only delivered via PrivatePub, so Notifier should
        # always care about them
        @notifyApp(model_name, payload)

  notifyApp: (model_name, payload) ->
    switch model_name
      when 'IdeaThread'
        event_name = 'notifier:update_idea_thread'
      when 'Idea'
        event_name = 'notifier:update_idea'
      when 'Vote'
        event_name = 'notifier:update_vote'
      when 'Comment'
        event_name = 'notifier:update_comment'
      when 'Activity'
        event_name = 'notifier:update_activity'
      when 'VotingRight'
        event_name = 'notifier:update_voting_right'

    @queueAction model_name, event_name, payload

  queueAction: (model_name, event_name, payload) ->
    @action_queue.add
      model_name: model_name
      mediator_event_name: event_name
      payload: payload

  createWebNotification: (model_name, payload) ->
    notification = new NotificationCreator(model_name, payload)
    if notification.attributes
      @notifyWeb notification.attributes.title, notification.attributes.content

  createAudioNotification: (model_name, payload) ->
    unless payload.deleted
      unless payload.user_id is mediator.user.get('id')
        if payload.user and payload.user.autocomplete_search
          if @accessToThread(model_name, payload)
            new AudioNotification(@stage, payload.user.autocomplete_search, @audio_bus)

  accessToThread: (model_name, payload) ->
      switch model_name
        when 'IdeaThread'
          thread_id = payload.id
        when 'Vote'
          thread_id = payload.idea_thread_id
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