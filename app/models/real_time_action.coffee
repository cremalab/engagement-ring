Model = require 'models/base/model'

module.exports = class RealTimeAction extends Model
  defaults:
    model_name: ''
    # class name from the API. Currently already being delivered.
    payload: {}
    # the JSON data delivered by the server. Already being used
    mediator_event_name: ''
    # the name of the mediator event that should be published at the time of Action Queue execution
    published: false

  fire: ->
    Chaplin.mediator.publish @get('mediator_event_name'), @get('payload')
    @set 'published', true
    @trigger 'fired'
    console.log "Pubished event #{@get('mediator_event_name')}"
    return @