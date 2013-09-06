Model = require '/models/base/model'

module.exports = class User extends Model
  defaults:
    email: null

  urlRoot: 'http://localhost:3000/users/'
  # validate: ->
  #   if !@email or !@password
  #     return 'Please complete required fields'

  toJSON: ->
    profile = this.get('profile')
    new_attr = _.clone(this.attributes)
    delete new_attr.profile
    json = {user : new_attr}
    _.extend json.idea, {profile_attributes: profile}
    return json