View = require 'views/base/form_view'
DateInputView = require 'views/form_elements/date_input_view'

module.exports = class IdeaEditView extends View
  template: require './templates/edit'
  className: 'idea edit'
  key_bindings:
    'enter': 'save'
    'esc'  : 'exit'
  events:
    'click .submit': 'save'
    'click .cancel': 'exit'
  listen:
    'change model': 'displayWhen'

  initialize: (options) ->
    super
    @collection_view = options.collection_view

  render: ->
    super
    Mousetrap.unbind('n')
    # @natural_input = @$el.find('.natural-language')
    @natural_input = new DateInputView
      model: @model
      attr: 'when'
      el: @$el.find('.natural-language')

  exit: ->
    @collection_view.escapeForm @model
    @collection_view.setupKeyBindings()

  showDetails: ->
    @translateDate()
    details_view = new IdeaDetailsEditView container: @$el, model: @model
    @subview 'details_view', details_view
    @natural_input.remove()

  save: ->
    @updateModelFromFields =>
      @collection_view.save(@model)

  displayWhen: (model) ->
    changed = _.keys model.changed
    if changed.indexOf('when') > -1
      if model.changed.when is undefined or model.changed.when is null
        @$el.find('.when').text('')
      else
        @$el.find('.when').text moment(@model.get('when')).format("dddd MMM D, ha")

  updateModelFromFields: (callback) ->
    description = @$el.find("[name='description']").val()
    description = $.trim(description)
    @model.set 'description', description
    callback ->
      return