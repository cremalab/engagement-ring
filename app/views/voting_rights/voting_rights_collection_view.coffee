CollectionView = require 'views/base/collection-view'
VotingRight = require 'models/voting_right'
VotingRightView = require 'views/voting_rights/voting_right_view'

module.exports = class VotingRightsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  itemView: VotingRightView
  listen:
    'add collection': 'setThreadID'

  initialize: (options) ->
    super
    @idea_thread = options.idea_thread

  initItemView: (model) ->
    new VotingRightView model: model, collection_view: @

  setThreadID: (voting_right,b,c) ->
    unless @idea_thread.isNew()
      voting_right.set 'idea_thread_id', @idea_thread.get('id')
      voting_right.save()