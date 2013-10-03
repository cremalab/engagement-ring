CollectionView = require 'views/base/collection-view'
MembershipView = require 'views/memberships/membership_view'

module.exports = class MembershipsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  itemView: MembershipView