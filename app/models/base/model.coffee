# Base model.
utils = require 'lib/utils'
module.exports = class Model extends Chaplin.Model
  initialize: ->
    super
    @apiURL = utils.apiURL