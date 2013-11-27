Error = require 'models/error'
Collection = require 'collections/base/collection'

module.exports = class ErrorsCollection extends Collection
  model: Error