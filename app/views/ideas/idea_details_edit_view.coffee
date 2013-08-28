View = require 'views/base/form_view'

module.exports = class IdeaDetailsEditView extends View
  template: require './templates/details_edit'
  tagName: 'section'
  className: 'details'
  key_bindings:
    'enter': 'save'

  render: ->
    super
    Mousetrap.unbind('n')

  save: ->
    console.log 'save'