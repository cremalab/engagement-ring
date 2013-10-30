Collection = require 'models/base/collection'
IdeaThread = require 'models/idea_thread'
VotingRights = require 'collections/voting_rights_collection'

module.exports = class IdeaThreads extends Collection
  model: IdeaThread
  urlRoot: ->
    return Chaplin.mediator.apiURL('/idea_threads')
  url: Chaplin.mediator.apiURL('/idea_threads')

  initialize: ->
    super
    @subscribeEvent 'find_thread', @findIdeaThread
    @subscribeEvent 'notifier:update_idea_thread', @updateIdeaThread

  comparator: (a,b) ->
    a_time = a.get('updated_at')
    b_time = b.get('updated_at')
    if moment(a_time).isBefore(b_time)
      return 1
    else
      return -1

  findIdeaThread: (thread_id, callback) ->
    result = @findWhere
      id: thread_id
    callback(result)

  updateIdeaThread: (attributes) ->
    existing = @findWhere
      id: attributes.id
    if attributes.deleted
      @remove(existing) if existing

    else
      idea_thread = new IdeaThread(attributes)
      rights = idea_thread.get('voting_rights')
      right = rights.findWhere
        user_id: Chaplin.mediator.user.get('id')
      if right
        if existing
          existing.set(attributes)
        else
          idea_thread
          @add idea_thread
      else
        @remove(existing)