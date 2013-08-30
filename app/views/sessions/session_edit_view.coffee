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
    e.stopPropagation()
    @setCreds()
    e.preventDefault()
    console.log @model
    if @model.isValid()
      @publishEvent 'login', @model
  setCreds: ->
    email = @$el.find("[name='email']").val()
    password = @$el.find("[name='password']").val()
    @model.set
      email: email
      password: password