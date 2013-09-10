CollectionView = require 'views/base/collection-view'
VotingRight = require 'models/voting_right'
VotingRightView = require 'views/voting_rights/voting_right_view'

module.exports = class VotingRightsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  itemView: VotingRightView
