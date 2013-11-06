CollectionView = require 'views/base/collection-view'
Group     = require 'models/group'
GroupView = require 'views/groups/group_view'
show_template = require './templates/idea_show'

module.exports = class IdeaGroupsCollectionView extends CollectionView
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
    new @itemView model: model, collection_view: @, template: show_template

  setupGroups: ->
    if @collection.length is 0
      @collection.fetch()
