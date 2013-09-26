CollectionView = require 'views/base/collection-view'
Group     = require 'models/group'
GroupView = require 'views/groups/group_view'
template  = require './templates/ideas_collection'
show_template = require './templates/show'

module.exports = class GroupsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  template: template
  listSelector: '.groups'
  itemView: GroupView
  fallbackSelector: '.empty'

  initialize: ->
    super
    @current_user = Chaplin.mediator.user
    @setupGroups()

  initItemView: (model) ->
    new @itemView model: model, collection_view: @, template: show_template

  setupGroups: ->
    if @collection.length is 0
      @collection.fetch()
