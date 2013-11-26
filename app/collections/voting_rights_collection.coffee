Collection  = require 'collections/base/collection'
VotingRight = require 'models/voting_right'
Group       = require 'models/group'

module.exports = class VotingRights extends Collection
  model: VotingRight
  urlRoot: ->
    Chaplin.mediator.apiURL('/voting_rights')

  saveAsGroup: (name) ->
    group = new Group
      voting_rights: @
      name: name
      owner_id: Chaplin.mediator.user.get('id')
    @publishEvent 'save_group', group
