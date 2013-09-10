View = require 'views/base/view'
Tag = require 'models/tag'
template = require './templates/tag'

module.exports = class AutocompleteItem extends View
  autoRender: true
  template: template
  listen:
    'change:active model': 'setActiveClass'
  events:
    'click': 'activate'
  initialize: (options) ->
    console.log options
    # if options.collectionView.options.item_template_base
    #   @templateName = "#{options.collectionView.options.item_template_base}/list_item"
    # else
    #   @templateName = 'tags/show'
    # super
    @collectionView = options.collectionView if options && options.collectionView
  activate: ->
    old_active = @model.collection.findWhere active: true
    old_active.set('active', false) if old_active
    @model.set 'active', true
    @collectionView.addToRelatedCollection(@model)
  setActiveClass: ->
    if @model.get('active')
      @$el.addClass 'selected'
    else
      @$el.removeClass 'selected'