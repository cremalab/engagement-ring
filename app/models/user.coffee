Model = require '/models/base/model'
Profile = require 'models/profile'

module.exports = class User extends Model
  defaults:
    email: null
    profile: new Profile()

  urlRoot: ->
    Chaplin.mediator.apiURL('/users')

  toJSON: ->
    profile = this.get('profile').toJSON()
    new_attr = _.clone(this.attributes)
    delete new_attr.auth
    delete new_attr.profile
    json = {user : new_attr}
    _.extend json.user, {profile_attributes: profile}
    return json

  parse: (user) ->
    profile = new Profile(user.profile)
    user.profile = profile
    user

  initialize: ->
    super
    unless @get('profile').constructor.name is 'Profile'
      profile = new Profile(@get('profile'))
      @set('profile', profile)

  display_name: ->
    if @get('profile').get('first_name')
      return @get('profile').get('first_name')
    else
      return @get 'email'

  save: ->
    _.omit @, 'notifications'
    super