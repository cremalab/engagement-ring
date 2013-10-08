Model = require 'models/base/model'

module.exports = class Alert extends Model
  initialize: ->
    super
    console.log @