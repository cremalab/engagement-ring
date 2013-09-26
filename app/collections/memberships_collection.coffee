Collection = require 'models/base/collection'
Membership = require 'models/membership'

module.exports = class Memberships extends Collection
  model: Membership
  urlRoot: ->
    Chaplin.mediator.apiURL('/memberships')