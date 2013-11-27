Collection = require 'collections/base/collection'
Vote = require 'models/vote'

module.exports = class Votes extends Collection
  model: Vote
  urlRoot: ->
    Chaplin.mediator.apiURL('/votes')
  initialize: (options) ->
    super
    @current_user = Chaplin.mediator.user
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

  currentUserVote: ->
    @findWhere
      user_id: @current_user.get('id')

  voteOnIdea: (idea_id) ->
    if @currentUserVote()
      @currentUserVote().destroy()
    else
      @create
        user_id: @current_user.get('id')
        idea_id: idea_id
        user_name: @current_user.display_name
        user:
          email: @current_user.get('email')
          id: @current_user.get('id')