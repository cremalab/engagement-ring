Model = require '/models/base/model'

module.exports = class User extends Model
  defaults:
    email: null
    password: null

  urlRoot: '/users'