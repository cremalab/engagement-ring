View = require 'views/base/form_view'

module.exports = class IdeaDetailsEditView extends View
  template: require './templates/details_edit'
  tagName: 'section'
  className: 'details'

  render: ->
    super
    console.log @model