Model = require 'models/base/model'
Memberships = require 'collections/memberships_collection'

module.exports = class Group extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/groups')

  initialize: (options) ->
    super
    memberships = new Memberships
    @set 'memberships', memberships

    options.voting_rights.each (right) ->
      user_id = right.get('user_id')
      memberships.add
        user_id: user_id


  toJSON: ->
    memberships = this.get('memberships').toJSON()
    new_attr = _.clone(this.attributes)
    delete new_attr.memberships
    delete new_attr.voting_rights
    json = {group : new_attr}
    _.extend json.group, {memberships_attributes: memberships}
    return json