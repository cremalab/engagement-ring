Collection = require 'models/base/collection'
Vote = require 'models/vote'

module.exports = class Votes extends Collection
  model: Vote
  urlRoot: ->
    Chaplin.mediator.apiURL('/votes')
  initialize: ->
    super
    @subscribeEvent 'notifier:update_vote', @checkDestroy

  checkDestroy: (data) ->
    if data.deleted
      vote = @findWhere
        id: data.id
      if vote
        @remove(vote)

