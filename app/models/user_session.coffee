Model = require 'models/base/model'

module.exports = class UserSession extends Model
  api_url: '/sessions'
  defaults:
    email: ''
    password: ''