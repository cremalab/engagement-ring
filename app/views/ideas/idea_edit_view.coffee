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

  initialize: (options) ->
    super
    @collection_view = options.collection_view

  render: ->
    super
    Mousetrap.unbind('n')

  exit: ->
    @collection_view.escapeForm @model
    @collection_view.setupKeyBindings()
    @publishEvent 'escapeForm'

  save: ->
    @updateModelFromFields =>
      @collection_view.save(@model)

  updateModelFromFields: (callback) ->
    description = @$el.find("[name='description']").val()
    description = $.trim(description)
    @model.set 'description', description
    callback ->
      return