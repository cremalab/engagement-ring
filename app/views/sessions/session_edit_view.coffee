template = require './templates/form'
View = require 'views/base/form_view'

module.exports = class SessionEditView extends View
  autoRender: true
  tagName: 'form'
  template: template
  events:
    "submit": 'save'

  save: (e) ->
    e.preventDefault()
    if @model.isValid()
      @publishEvent 'login', @model