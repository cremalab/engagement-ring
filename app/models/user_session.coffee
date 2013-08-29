Model = require 'models/base/model'

module.exports = class UserSession extends Model
  url: 'http://localhost:3000/sessions'
  defaults:
    email: ''
    password: ''