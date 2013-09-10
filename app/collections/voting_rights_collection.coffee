Collection = require 'models/base/collection'
VotingRight = require 'models/voting_right'

module.exports = class VotingRights extends Collection
  model: VotingRight
  urlRoot: ->
    Chaplin.mediator.apiURL('/voting_rights')

