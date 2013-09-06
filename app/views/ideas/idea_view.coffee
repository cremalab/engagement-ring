View = require 'views/base/view'
Vote = require 'models/vote'
Votes = require 'collections/votes_collection'
VotesView = require 'views/votes/votes_collection_view'

module.exports = class IdeaView extends View
  template: require './templates/show'
  className: (options) ->
    if @model.get "original"
      "idea original"
    else
      "idea"
  regions:
    votes: '.votes'
  events:
    'click .edit': 'edit'
    'click .vote': 'vote'
  textBindings: true


  render: ->
    super
    @votes = @model.get('votes')
    votes_view = new VotesView
      collection: @votes
      region: 'votes'
      el: @$el.find('.votes')
      idea_view: @
    @subview 'votes', votes_view

    @listenTo @votes, 'add', @updateVotesCount
    @listenTo @votes, 'remove', @updateVotesCount

  edit: (e) ->
    @publishEvent 'edit_idea', @model

  vote: (e) ->
    if @user_vote
      @user_vote.destroy()
    else
      vote = new Vote
        user_id: Chaplin.mediator.user.get('id')
        idea_id: @model.get('id')
      @publishEvent 'vote', vote, @model, @votes

  toggleUserVote: (voted, user_vote) ->
    if voted
      @$el.find(".vote").addClass('voted')
      @user_vote = user_vote
    else
      @$el.find(".vote").removeClass('voted')
      @user_vote = null

  updateVotesCount: (a,b) ->
    @model.set('total_votes', @votes.length)