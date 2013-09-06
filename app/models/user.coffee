Model = require '/models/base/model'
Profile = require 'models/profile'

module.exports = class User extends Model
  defaults:
    email: null
    profile: new Profile()

  urlRoot: 'http://localhost:3000/users/'
  # validate: ->
  #   if !@email or !@password
  #     return 'Please complete required fields'

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

  display_name: ->
    if @get('profile').get('first_name')
      return @get('profile').get('first_name')
    else
      return @get 'email'