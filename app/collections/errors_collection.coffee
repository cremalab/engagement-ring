Error = require 'models/error'

module.exports = class ErrorsCollection extends Chaplin.Collection
  model: Error