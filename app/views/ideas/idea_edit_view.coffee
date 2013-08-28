View = require 'views/base/form_view'
IdeaDetailsEditView = require './idea_details_edit_view'

module.exports = class IdeaEditView extends View
  template: require './templates/edit'
  key_bindings:
    'enter': 'showDetails'
    'esc'  : 'exit'

  initialize: (options) ->
    super
    @collection_view = options.collection_view

  render: ->
    super

    @natural_input = @$el.find('.natural-language')

    unless @model.isNew()
      @showDetails()

  exit: ->
    @collection_view.escapeForm @model
    @collection_view.setupKeyBindings()


  translateDate: ->
    input_val = @natural_input.val()
    parsed = chrono.parse(input_val)
    if parsed.length > 0
      date = parsed[0]
      @model.set 'when', date.startDate
      title = date.concordance.replace(date.text, '').replace('  ', ' ')
      @model.set('title', title)
      @$el.find('.when').text moment(date.startDate).format("dddd MMM D, ha")
    else
      @model.set('title', input_val)
      if @model.get 'when'
        @model.set 'when', null

  showDetails: ->
    @translateDate()
    details_view = new IdeaDetailsEditView container: @$el, model: @model
    @subview 'details_view', details_view
    @natural_input.remove()