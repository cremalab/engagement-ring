View = require 'views/base/view'

module.exports = class CurrentUserInfoView extends View
  autoRender: true
  template: require './templates/current_user_info'
  textBindings: true
  events:
    'click .notifications': 'setNotificationPrefs'

  listen:
    'change model': 'storeUser'

  initialize: ->
    super
    @checkNotificationPrefs()

  storeUser: ->
    store.set('current_user', @model.attributes)

  checkNotificationPrefs: ->
    @browser_permission = window.webkitNotifications.checkPermission()

    if @model.get('notifications')
      if @browser_permission != 0
        @model.set('notifications', false)
        attrs = _.clone @model.attributes
        delete attrs.profile
        @model.save attrs,
          success: (user, response) =>
            @publishEvent 'set_current_user', response
            @render()

    else
      @model.set('notifications', false)
      attrs = _.clone @model.attributes

  setNotificationPrefs: (e) ->
    window.webkitNotifications.requestPermission()
    e.preventDefault() if e

    if @model.get('notifications') is true
      @model.set('notifications', false)
    else
      if window.webkitNotifications.checkPermission() is 0
        @model.set('notifications', true)
      else
        window.webkitNotifications.requestPermission (whatever) =>
          if window.webkitNotifications.checkPermission() is 0
            @model.set('notifications', true)
            @render()

    attrs = _.clone @model.attributes
    delete attrs.profile
    @model.save attrs,
      success: (user, response) =>
        @publishEvent 'set_current_user', response
        @render()