View = require 'views/base/view'
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
    # console.log @model
    @votes = @model.get('votes')
    votes_view = new VotesView
      collection: @votes
      region: 'votes'
      el: @$el.find('.votes')
      idea_view: @
    @subview 'votes', votes_view

    @listenTo @votes, 'add', @updateVotesCount

  edit: (e) ->
    @publishEvent 'edit_idea', @model

  vote: (e, b) ->
    @votes.create
      user_id: Chaplin.mediator.user.get('id')
      idea_id: @model.get('id')
    , wait: true

  disableVoting: ->
    @$el.find('.vote').remove()

  updateVotesCount: ->
    @model.set('total_votes', @votes.size())