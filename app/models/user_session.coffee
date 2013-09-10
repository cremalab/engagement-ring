Model = require 'models/base/model'

module.exports = class UserSession extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/sessions')
  defaults:
    email: ''
    password: ''