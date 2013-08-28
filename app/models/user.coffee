Model = require '/models/base/model'

module.exports = class User extends Model
  defaults:
    email: null
    password: null

  urlRoot: 'http://localhost:3000/users'

  # validate: ->
  #   return 'no way'