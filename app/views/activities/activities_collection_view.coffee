CollectionView = require 'views/base/collection-view'
Activity     = require 'models/activity'
ActivityView = require 'views/activities/activity_view'
# template = require './templates/collection'

module.exports = class CommentsCollectionView extends CollectionView
  # template: template
  # listSelector: '.messages'
  itemView: ActivityView
  filterer: (item, index) ->
    return true if index < 11