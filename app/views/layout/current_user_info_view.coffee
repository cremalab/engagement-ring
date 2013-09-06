View = require 'views/base/view'

module.exports = class CurrentUserInfoView extends View
  autoRender: true
  className: 'user-info'
  tagName: 'section'
  template: require './templates/current_user_info'
  textBindings: true

  listen:
    'change model': 'storeUser'

  storeUser: ->
    store.set('current_user', @model.attributes)