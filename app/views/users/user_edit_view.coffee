template = require './templates/form'
View = require 'views/base/form_view'
ProfileEditView = require 'views/profiles/profile_edit_view'

module.exports = class RegistrationView extends View
  autoRender: true
  className: 'registreationNew'
  tagName: 'form'
  template: template
  events:
    "submit": 'save'

  save: (e) ->
    e.preventDefault() if e
    if @model.isValid()
      @publishEvent 'save_user', @model

  render: ->
    super
    @registerRegion 'profile', '.profile'
    profile_view = new ProfileEditView
      model: @model.get('profile')
      region: 'profile'
      autoRender: true
    @subview 'profile_view', profile_view