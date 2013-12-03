View = require 'views/base/view'
Tag = require 'models/tag'
template = require './templates/tag'

module.exports = class AutocompleteItem extends View
  autoRender: true
  template: template
  className: 'dropdownItem'
  listen:
    'change:active model': 'setActiveClass'
  events:
    'click': 'activate'
  initialize: (options) ->
    super
    @collectionView = options.collectionView if options && options.collectionView
  activate: ->
    old_active = @model.collection.findWhere active: true
    old_active.set('active', false) if old_active
    @model.set 'active', true
    @collectionView.addTag(@model)
  setActiveClass: ->
    if @model.get('active')
      @$el.addClass 'selected'
    else
      @$el.removeClass 'selected'