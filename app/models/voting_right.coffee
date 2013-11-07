Model = require '/models/base/model'

module.exports = class VotingRight extends Model
  defaults:
    idea_thread_id: null
    user_id: null
  urlRoot: ->
    Chaplin.mediator.apiURL('/voting_rights')

  toJSON: ->
    new_attr = _.clone(this.attributes)
    new_attr = _.pick new_attr, [
      'idea_thread_id',
      'user_id'
    ]
    return new_attr