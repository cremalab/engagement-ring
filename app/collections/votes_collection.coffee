Collection = require 'models/base/collection'
Vote = require 'models/vote'

module.exports = class Votes extends Collection
  model: Vote
  urlRoot: ->
    Chaplin.mediator.apiURL('/votes')
  initialize: (options) ->
    super
    @subscribeEvent 'notifier:update_vote', @updateVote

  updateVote: (data) ->
    if data.deleted
      @removeVote(data)
    else
      @addVote(data)

  addVote: (data) ->
    if data.idea_id is @idea.get('id')
      unless @idea.hasVote(data.id)
        @add(data)

  removeVote: (data) ->
    vote = @findWhere
      id: data.id
    if vote
      @remove(vote)

