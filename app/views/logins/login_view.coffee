template = require './templates/form'
View = require 'views/base/form_view'

module.exports = class LoginView extends View
  autoRender: true
  tagName: 'form'
  template: template
  events:
    "submit": 'save_session'

  save_session: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @setCreds()
    if @model.isValid()
      @publishEvent 'login', @model
      return false
  setCreds: ->
    email = @$el.find("[name='email']").val()
    password = @$el.find("[name='password']").val()
    @model.set
      email: email
      password: password