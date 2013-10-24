CollectionView = require 'views/base/collection-view'
Activity     = require 'models/activity'
ActivityView = require 'views/activities/activity_view'

module.exports = class ActivitiesFullCollectionView extends CollectionView
  itemView: ActivityView

  initialize: ->
    super
    @collection.fetch()

  render: ->
    super
    @$el.append("<a href='#' class='view-all-activity'>View all activity</a>")

  viewAll: (e) ->
    e.preventDefault()

  initItemView: (model) ->
    new ActivityView
      model: model
      full_view: true