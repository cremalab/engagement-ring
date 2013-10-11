View = require 'views/base/view'
Vote = require 'models/vote'
Votes = require 'collections/votes_collection'
VotesView = require 'views/votes/votes_collection_view'
Comments = require 'collections/comments_collection'
CommentsView = require 'views/comments/comments_collection_view'

module.exports = class IdeaView extends View
  template: require './templates/show'
  className: (options) ->
    if @model.get "original"
      "idea original"
    else
      "idea"
  events:
    'click .vote': 'vote'
    'click .comments': 'toggleComments'
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
    @model.set('edited', true)

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
      @$el.find(".vote").addClass('voted')
      vote.save vote.attributes,
        success: (vote) =>
          @votes.add(vote)

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
    @model.destroy()

  renderViewInCollection: (object) ->
    changed = _.keys(object.changed)
    if _.indexOf(changed, 'title') > 0
      @collection_view.renderItem(@model) if @collection_view

  toggleComments: (e) ->
    e.preventDefault()
    if @subview('comments')
      @removeSubview('comments')
    else

      # Create an empty collection unless one is cached
      unless @comments
        @comments = new Comments([], idea_id: @model.get('id'))

      comments_view = new CommentsView
        collection: @comments
        ## We'll probably stick this view in a higher-level
        ## application region:

        # region: 'sidepanel'
        container: @$el
      @subview('comments', comments_view)

