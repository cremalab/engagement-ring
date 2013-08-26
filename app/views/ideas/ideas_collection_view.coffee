CollectionView = require 'views/base/collection-view'
Idea = require 'views/ideas/idea_view'

module.exports = class IdeasCollectionView extends CollectionView
  itemView: Idea
