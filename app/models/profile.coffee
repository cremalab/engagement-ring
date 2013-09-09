Model = require '/models/base/model'

module.exports = class Profile extends Model
  defaults:
    first_name: null
    last_name:  null

  urlRoot: ->
    return Chaplin.mediator.apiURL('/profiles')