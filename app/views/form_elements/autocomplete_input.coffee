CollectionView = require 'views/base/collection-view'
TagView = require 'views/form_elements/tag_view'
AutocompleteList = require 'views/form_elements/autocomplete_list'
Tag = require 'models/tag'

module.exports = class AutocompleteInput extends CollectionView
  listSelector: "[module~='tag-list']"
  initialize: (options) ->
    super
    @delegate 'keyup', 'input', @checkKey
    @delegate 'keydown', 'input', @preventSubmission
    @source = options.source_collection
    @label = options.label
    @matches_collection = new Chaplin.Collection()
    @item_template_base = options.item_template_base
  render: ->
    super
    @autocomplete_list = new AutocompleteList
      collection: @matches_collection
      el: @$el.find("[region='auto-matches']")
      collectionView: @
      item_template_base: @item_template_base
    if @label
      @$el.find('label').prepend @label
    else
      @$el.find('label').remove()
  checkKey: (e) ->
    e.stopPropagation()
    action_keys = [13,38,40,37,39,16,91,17,18,93]
    unless _.indexOf(action_keys, e.keyCode) > -1
      @checkAutoComplete(e)
    else if _.indexOf([38,40], e.keyCode) > -1
      if e.keyCode == 38
        @autocomplete_list.moveActiveMatch(-1)
        @publishEvent 'autocomplete_list_up'
      else if e.keyCode == 40
        @autocomplete_list.moveActiveMatch(1)
        @publishEvent 'autocomplete_list_down'
    else if e.keyCode == 13
      if @autocomplete_list.active
        tag = @autocomplete_list.getValue()
        @addTag tag
  checkAutoComplete: (e) ->
    @matches_collection.reset()
    if $(e.target).val().length > 1
      matches = @source.filter (tag) =>
        search = tag.get('autocomplete_search')
        return  search.toLowerCase().indexOf($(e.target).val().toLowerCase()) > -1
      @matches_collection.set matches
  setValue: (tag) ->
    @$el.find('input').val(tag.get('autocomplete_search'))
      .data('value', tag.get('autocomplete_value')).focus()
    @matches_collection.reset()

  setCaretPosition: (pos) ->
    ctrl = @$el.find('input')
    if ctrl.setSelectionRange
      ctrl.focus()
      ctrl.setSelectionRange pos, pos
    else if ctrl.createTextRange
      range = ctrl.createTextRange()
      range.collapse true
      range.moveEnd "character", pos
      range.moveStart "character", pos
      range.select()
  preventSubmission: (e) ->
    if e.keyCode == 13
      e.stopPropagation()
      return false
  removeItem: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @dispose()