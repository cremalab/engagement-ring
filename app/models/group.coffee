Model        = require 'models/base/model'
Memberships  = require 'collections/memberships_collection'

module.exports = class Group extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/groups')

  initialize: (options) ->
    super

    if options.voting_rights
      memberships = new Memberships
      @set 'memberships', memberships
      options.voting_rights.each (right) ->
        user_id = right.get('user_id')
        memberships.add
          user_id: user_id
      @unset 'voting_rights'
    else if options.memberships
      memberships = new Memberships(options.memberships)
      @set 'memberships', memberships

  toJSON: ->
    memberships = this.get('memberships').toJSON()
    new_attr = _.clone(this.attributes)
    delete new_attr.memberships
    delete new_attr.voting_rights
    json = {group : new_attr}
    _.extend json.group, {memberships_attributes: memberships}
    return json

  prepareVotingRights: ->
    # remove current_user from list
    memberships = @get('memberships')
    current_user_right = memberships.findWhere
      user_id: Chaplin.mediator.user.get('id')

    # create an array to be added to the VotingRightsCollection
    memberships.remove(current_user_right)
    voting_rights_array = memberships.map (membership) ->
      result =
        user_id: membership.get('user_id')
        autocomplete_search: membership.get('autocomplete_search')
      result

    return voting_rights_array