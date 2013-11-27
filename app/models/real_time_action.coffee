Model = require 'models/base/model'

module.exports = class RealTimeAction extends Model
  defaults:
    model_name: ''
    # class name from the API. Currently already being delivered.
    payload: {}
    # the JSON data delivered by the server. Already being used
    mediator_event_name: ''
    # the name of the mediator event that should be published at the time of Action Queue execution