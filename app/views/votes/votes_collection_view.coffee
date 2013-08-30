View = require 'views/base/collection-view'
VoteView = require './vote_view'

module.exports = class VotesView extends View
  # template: require './templates/collection'
  itemView: VoteView
  autoRender: true
  autoAttach: true
  animationDuration: 0