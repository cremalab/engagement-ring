template = require './templates/form'
View = require 'views/base/form_view'
ProfileEditView = require 'views/profiles/profile_edit_view'
NotificationSettingsView = require 'views/users/notification_settings_view'

module.exports = class RegistrationView extends View
  autoRender: true
  className: 'registreationNew'
  tagName: 'form'
  template: template
  events:
    "submit": 'save'
  listen:
    "change model": 'learn'

  learn: (a,b) ->
    console.log a
    console.log b
    console.log @model

  save: (e) ->
    e.preventDefault() if e
    if @model.isValid()
      @publishEvent 'save_user', @model

  render: ->
    super
    @registerRegion 'profile', '.profile'
    @registerRegion 'notifications', '.notifications'
    profile_view = new ProfileEditView
      model: @model.get('profile')
      region: 'profile'
      autoRender: true
    @subview 'profile_view', profile_view

    notifications_view = new NotificationSettingsView
      model: @model.get('notification_setting')
      region: 'notifications'
      autoRender: true
    @subview 'notifications_view', notifications_view