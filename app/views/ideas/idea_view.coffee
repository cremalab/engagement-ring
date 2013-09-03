View = require 'views/base/view'
Votes = require 'collections/votes_collection'
VotesView = require 'views/votes/votes_collection_view'

module.exports = class IdeaView extends View
  template: require './templates/show'
  className: 'idea'
  regions:
    votes: '.votes'
  events:
    'click .edit': 'edit'
    'click .vote': 'vote'
  textBindings: true


  render: ->
    super
    @votes = new Votes @model.get('votes')
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

  vote: (e, b) ->
    @votes.create
      user_id: Chaplin.mediator.user.get('id')
      idea_id: @model.get('id')
    , wait: true

  disableVoting: ->
    @$el.find('.vote').hide()
  enableVoting: ->
    @$el.find('.vote').show()

  updateVotesCount: ->
    @model.set('total_votes', @votes.size())