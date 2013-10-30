Model = require '/models/base/model'
Profile = require 'models/profile'
NotificationSetting = require 'models/notification_setting'

module.exports = class User extends Model
  defaults:
    email: null
    profile: new Profile()
    notification_setting: new NotificationSetting()

  urlRoot: ->
    Chaplin.mediator.apiURL('/users')

  toJSON: ->
    profile = this.get('profile').toJSON()
    notifications = this.get('notification_setting').toJSON()
    new_attr = _.clone(this.attributes)
    delete new_attr.auth
    delete new_attr.profile
    delete new_attr.notification_setting
    json = {user : new_attr}
    _.extend json.user, {profile_attributes: profile}
    _.extend json.user, {notification_setting_attributes: notifications}
    return json

  parse: (user) ->
    profile = new Profile(user.profile)
    notification = new NotificationSetting(user.notification_setting)
    user.notification_setting = notification
    user.profile = profile
    user

  initialize: ->
    super
    unless @get('profile').constructor.name is 'Profile'
      profile = new Profile(@get('profile'))
      @set('profile', profile)
    unless @get('notification_setting').constructor.name is 'NotificationSetting'
      notification = new NotificationSetting(@get('notification_setting'))
      @set('notification_setting', notification)

  display_name: ->
    if @get('profile').get('first_name')
      return @get('profile').get('first_name')
    else
      return @get 'email'

  save: ->
    _.omit @, 'notifications'
    super