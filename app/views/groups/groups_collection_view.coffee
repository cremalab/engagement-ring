CollectionView = require 'views/base/collection-view'
Group     = require 'models/group'
GroupView = require 'views/groups/group_view'
template = require './templates/collection'

module.exports = class GroupsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  itemView: GroupView

  initialize: ->
    super
    @current_user = Chaplin.mediator.user
    @setupGroups()

  initItemView: (model) ->
    new @itemView model: model, collection_view: @

  setupGroups: ->
    if @collection.length is 0
      @collection.fetch
        success: (coll, res) ->
          console.log coll
          console.log res
