View = require 'views/base/collection-view'
VoteView = require './vote_view'

module.exports = class VotesView extends View
  # template: require './templates/collection'
  itemView: VoteView
  animationDuration: 0

  initialize: (options) ->
    super
    @idea_view = options.idea_view