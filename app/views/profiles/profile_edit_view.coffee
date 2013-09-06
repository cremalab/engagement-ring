template = require './templates/form'
View = require 'views/base/form_view'
DateInputView = require 'views/form_elements/date_input_view'

module.exports = class ProfileEditView extends View
  autoRender: true
  className: 'profileEdit'
  tagName: 'form'
  template: template
