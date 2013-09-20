CollectionView = require 'views/base/collection-view'
AutocompleteItem = require 'views/form_elements/autocomplete_item'


module.exports = class AutocompleteList extends CollectionView
  itemView: AutocompleteItem
  animationDuration: 0
  autoRender: true
  listen:
    'visibilityChange': 'resetIndex'
  initialize: (options) ->
    super
    @active = false
    @currentIndex = -1
    @collectionView = options.collectionView if options && options.collectionView
    @listenTo @collection, 'reset', @hideElement
    @listenTo @collection, 'add', @updateListStatus
  render: ->
    super
    @$el.hide()
  moveActiveMatch: (increment) ->
    size = @collection.size()
    unless (@currentIndex == (size - 1) && increment == 1) or (@currentIndex == 0 && increment == -1 )
      index = Number(@currentIndex) + Number(increment)
      @setActiveItem(index)
    @updateListStatus()
  resetIndex: ->
    @currentIndex = -1
    @$el.show()
  hideElement: ->
    @$el.hide()
  getValue: ->
    return @current_model
  unsetActiveItem: ->
    current = @collection.findWhere active: true
    current.set('active', false) if current
  setActiveItem: (index) ->
    @unsetActiveItem()
    @currentIndex = index
    @current_model = @collection.at(@currentIndex)
    @current_model.set('active', true) if @current_model
  updateListStatus: ->
    if @currentIndex > -1
      @active = true
    else
      @active = false
  addToRelatedCollection: (tag) ->
    @collectionView.addTag(tag)