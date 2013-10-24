CollectionView = require 'views/base/collection-view'
Activity     = require 'models/activity'
ActivityView = require 'views/activities/activity_view'
ActivitiesFullCollectionView = require 'views/activities/activities_full_collection_view'
ActivitiesCollection = require 'collections/activities_collection'

module.exports = class ActivitiesCollectionView extends CollectionView
  itemView: ActivityView
  events:
    'click .view-all-activity': 'viewAll'

  render: ->
    super
    @$el.append("<a href='#' class='view-all-activity'>View all activity</a>")

  viewAll: (e) ->
    e.preventDefault()

    full_collection = new ActivitiesCollection([], @collection.idea)

    activity_feed = new ActivitiesFullCollectionView
      collection: full_collection
      # Put this in the sidebar region or modal
      # region: 'sidepanel'
      region: 'flash_messages'
      # container: @$el