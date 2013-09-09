Collection = require 'models/base/collection'
Idea = require 'models/idea'

module.exports = class Ideas extends Collection
  model: Idea
  urlRoot: ->
    Chaplin.mediator.apiURL('/ideas')
  comparator: (idea) ->
    return idea.get('total_votes') * -1

