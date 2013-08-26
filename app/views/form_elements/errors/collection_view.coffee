CollectionView = require 'views/base/collection-view'
ErrorView = require 'views/form_elements/errors/error_view'
template = require './templates/errors_collection_view'

module.exports = class ErrorsCollectionView extends CollectionView
  itemView: ErrorView
  animationDuration: 0
  listen:
    'add collection': 'showView'

  render: ->
    super
    if @collection.size() == 0
      @$el.hide()
  showView: ->
    if @collection.size() > 0
      @$el.show()