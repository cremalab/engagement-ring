Model = require 'models/base/model'
Memberships = require 'collections/memberships_collection'

module.exports = class Group extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/groups')

  initialize: (voting_rights) ->
    super
    memberships = new Memberships
    voting_rights.each (right) ->
      user_id = right.get('user_id')
      memberships.add
        user_id: user_id

    console.log 'memberships'
    console.log memberships
