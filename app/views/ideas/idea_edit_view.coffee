View = require 'views/base/form_view'

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
    @listenTo @model, 'change:id', @dispose

  render: ->
    super
    Mousetrap.unbind('n')

  exit: ->
    @collection_view.setupKeyBindings()
    @model.set('edited', false)

  save: ->
    @updateModelFromFields =>
      @model.save()

  updateModelFromFields: (callback) ->
    description = @$el.find("[name='description']").val()
    description = $.trim(description)
    @model.set 'description', description
    callback ->
      return