Model = require 'models/base/model'

module.exports = class Notifier extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    if mediator.user.get('subscription')
      secret = 'secret'
      subscription = mediator.user.get('subscription')
      for_signature = "#{secret}#{subscription.channel}#{subscription.timestamp}"
      signature = new SHA1(for_signature).hexdigest()

      PrivatePub.sign
        server: "http://localhost:9292/faye"
        channel: subscription.channel
        signature: signature
        timestamp: subscription.timestamp

      PrivatePub.subscribe "/message/channel", (data, channel) =>
        @notify(data)

  notify: (data) ->
    data = jQuery.parseJSON(data.message)
    model_name = data.model_name
    delete data.model_name
    switch model_name
      when 'IdeaThread'
        mediator.publish 'notifier:update_idea_thread', data
      when 'Idea'
        mediator.publish 'notifier:update_idea', data
      when 'Vote'
        mediator.publish 'notifier:update_vote', data
