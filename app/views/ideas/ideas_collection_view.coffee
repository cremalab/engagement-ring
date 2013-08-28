CollectionView = require 'views/base/collection-view'
IdeaView = require 'views/ideas/idea_view'
IdeaEditView = require 'views/ideas/idea_edit_view'

module.exports = class IdeasCollectionView extends CollectionView

  initItemView: (model) ->
    if model.isNew()
      new IdeaEditView model: model
    else
      new IdeaView model: model