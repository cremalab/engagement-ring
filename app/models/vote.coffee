Model = require '/models/base/model'

module.exports = class Vote extends Model
  defaults:
    idea_id: null       # fk
    user_id: null       # fk
  urlRoot: ->
    Chaplin.mediator.apiURL('/votes')
  initialize: ->
    super
    @bind 'remove', =>
      @destroy()