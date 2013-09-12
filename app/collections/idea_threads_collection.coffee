Collection = require 'models/base/collection'
IdeaThread = require 'models/idea_thread'

module.exports = class IdeaThreads extends Collection
  model: IdeaThread
  urlRoot: ->
    return Chaplin.mediator.apiURL('/idea_threads')
  url: Chaplin.mediator.apiURL('/idea_threads')
  initialize: ->
    super
    @subscribeEvent 'notifier:update_idea_thread', @addIdeaThread
  comparator: (a,b) ->
    a_time = a.get('updated_at')
    b_time = b.get('updated_at')
    if moment(a_time).isBefore(b_time)
      return 1
    else
      return -1


  addIdeaThread: (attributes) ->
    thing = new IdeaThread attributes
    @add thing