Model = require '/models/base/model'

module.exports = class VotingRight extends Model
  defaults:
    idea_thread_id: null       # fk
    user_id: null       # fk
  urlRoot: ->
    Chaplin.mediator.apiURL('/voting_rights')
  initialize: ->
    super
    @bind 'remove', =>
      @destroy()