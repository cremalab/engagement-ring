Collection = require 'collections/base/collection'

module.exports = class Ideas extends Collection
  model: Chaplin.Model
  url: ->
    Chaplin.mediator.apiURL('/user_search')


