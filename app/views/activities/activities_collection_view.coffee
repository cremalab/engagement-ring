CollectionView = require 'views/base/collection-view'
Activity     = require 'models/activity'
ActivityView = require 'views/activities/activity_view'
# template = require './templates/collection'

module.exports = class CommentsCollectionView extends CollectionView
  itemView: ActivityView