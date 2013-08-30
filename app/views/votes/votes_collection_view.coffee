View = require 'views/base/collection-view'
VoteView = require './vote_view'

module.exports = class VotesView extends View
  # template: require './templates/collection'
  itemView: VoteView
  animationDuration: 0
  listen:
    'add collection': 'checkUserVote'
    'remove collection': 'checkUserVote'

  initialize: (options) ->
    super
    @idea_view = options.idea_view
    @checkUserVote()

  checkUserVote: (model) ->
    user_vote = @collection.findWhere
      user_id: Chaplin.mediator.user.get('id')
    if user_vote
      @disableVoting()
    else
      @enableVoting()

  disableVoting: ->
    @idea_view.disableVoting()
  enableVoting: ->
    @idea_view.enableVoting()