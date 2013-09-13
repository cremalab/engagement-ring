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
  events:
    'click .vote': 'vote'
    'click .edit': 'edit'
    'click .destroy': 'destroy'
  # listen:
  #   'model change': 'renderViewInCollection'
  textBindings: true

  initialize: (options) ->
    super
    @collection_view = options.collection_view

  render: ->
    super
    @votes = @model.get('votes')
    votes_view = new VotesView
      collection: @votes
      el: @$el.find('.ideaVoters')
      idea_view: @
    @subview 'votes', votes_view

    @listenTo @votes, 'add', @updateVotesCount
    @listenTo @votes, 'remove', @updateVotesCount

  edit: (e) ->
    e.preventDefault()
    @collection_view.editIdea @model

  vote: (e) ->
    if @user_vote
      @user_vote.destroy()
    else
      vote = new Vote
        user_id: Chaplin.mediator.user.get('id')
        idea_id: @model.get('id')
      @collection_view.checkVote vote, @model

  toggleUserVote: (voted, user_vote) ->
    if voted
      @$el.find(".vote").addClass('voted')
      @user_vote = user_vote
    else
      @$el.find(".vote").removeClass('voted')
      @user_vote = null

  updateVotesCount: (a,b) ->
    @model.set('total_votes', @votes.length)

  destroy: (e) ->
    e.preventDefault() if e
    @model.destroy
      success: =>
        @collection_view.checkEmpty()

  renderViewInCollection: ->
    @collection_view.renderItem(@model) if @collection_view
