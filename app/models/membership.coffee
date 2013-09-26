Model = require 'models/base/model'

module.exports = class Membership extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/memberships')