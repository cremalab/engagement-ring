template = require './templates/notification_settings_form'
View = require 'views/base/form_view'

module.exports = class NotificationSettingsView extends View
  autoRender: true
  tagName: 'form'
  template: template