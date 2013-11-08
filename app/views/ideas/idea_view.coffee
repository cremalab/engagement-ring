View = require 'views/base/view'
Vote = require 'models/vote'
Votes = require 'collections/votes_collection'
VotesView = require 'views/votes/votes_collection_view'
ActivitiesView = require 'views/activities/activities_collection_view'
Comments = require 'collections/comments_collection'

module.exports = class IdeaView extends View
  template: require './templates/show'
  className: (options) ->
    if @model.get "original"
      "idea original"
    else
      "idea"
  events:
    'click button.vote': 'vote'
    'click button.edit': 'edit'
    'click .destroy': 'destroy'
    'click button.comments': 'showActivityFeed'
  textBindings: true
  regions:
    activities: '.activities'

  initialize: (options) ->
    super
    @collection_view = options.collection_view
    @idea_thread = options.idea_thread
    @listenTo @model, 'change', @renderViewInCollection
    @listenTo @model, 'save', @renderViewInCollection
    @votes = @model.get('votes')

  render: ->
    super
    @createVotesView()
    @createActivitiesView()
    @updateVoteButtonUI()

    @listenTo @votes, 'add', @updateVotesCount
    @listenTo @votes, 'remove', @updateVotesCount

  edit: (e) ->
    e.preventDefault()
    @model.set('edited', true)

  createVotesView: ->
    votes_view = new VotesView
      collection: @votes
      el: @$el.find('.ideaVoters')
      idea_view: @
    @subview 'votes', votes_view

  createActivitiesView: ->
    activities_view = new ActivitiesView
      collection: @model.get('recent_activities')
      region: 'activities'
      idea_view: @
    @subview 'activity_feed', activities_view

  showActivityFeed: (e) ->
    e.preventDefault()
    @subview('activity_feed').viewAll()

  vote: (e) ->
    e.preventDefault()
    @model.performUserVote()

  updateVotesCount: ->
    @updateVoteButtonUI()
    @model.set('total_votes', @votes.length)
    @collection_view.resort()

  updateVoteButtonUI: ->
    if @votes.currentUserVote()
      @$el.find('button.vote').addClass('voted')
    else
      @$el.find('button.vote').removeClass('voted')


  destroy: (e) ->
    e.preventDefault() if e
    @model.destroy()

  renderViewInCollection: (object) ->
    changed = _.keys(object.changed)
    if _.indexOf(changed, 'title') > 0
      @collection_view.renderItem(@model) if @collection_view

