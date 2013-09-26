Collection = require 'models/base/collection'
Group      = require 'models/group'

module.exports = class Groups extends Collection
  model: Group
  url: ->
    Chaplin.mediator.apiURL('/groups')