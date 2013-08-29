template = require './templates/form'
View = require 'views/base/form_view'

module.exports = class RegistrationView extends View
  autoRender: true
  className: 'registreationNew'
  tagName: 'form'
  template: template
  events:
    "click button": 'save'

  save: (e) ->
    e.preventDefault()
    if @model.isValid()
      @publishEvent 'save_user', @model