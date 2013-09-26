Collection  = require 'models/base/collection'
VotingRight = require 'models/voting_right'
Group       = require 'models/group'

module.exports = class VotingRights extends Collection
  model: VotingRight
  urlRoot: ->
    Chaplin.mediator.apiURL('/voting_rights')

  saveAsGroup: ->
    group = new Group(@)
    @publishEvent 'save_group', group
