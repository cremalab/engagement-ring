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
  textBindings: true

  initialize: (options) ->
    super
    @collection_view = options.collection_view
    @listenTo @model, 'change', @renderViewInCollection
    @listenTo @model, 'save', @renderViewInCollection

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
      current_user = Chaplin.mediator.user
      vote = new Vote
        user_id: current_user.get('id')
        idea_id: @model.get('id')
        user_name: current_user.display_name
        user:
          email: current_user.get('email')
          id: current_user.get('id')
      vote.save()

  toggleUserVote: (voted, user_vote) ->
    if voted
      @$el.find(".vote").addClass('voted')
      @user_vote = user_vote
    else
      @$el.find(".vote").removeClass('voted')
      @user_vote = null

  updateVotesCount: (a,b) ->
    @model.set('total_votes', @votes.length)
    @collection_view.resort()

  destroy: (e) ->
    e.preventDefault() if e
    @model.destroy
      success: (idea,b) =>
        @collection_view.collection.remove(idea)
        @collection_view.checkEmpty()

  renderViewInCollection: (object) ->
    changed = _.keys(object.changed)
    if _.indexOf(changed, 'title') > 0
      @collection_view.renderItem(@model) if @collection_view
