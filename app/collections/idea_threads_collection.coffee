Collection = require 'collections/base/collection'
IdeaThread = require 'models/idea_thread'
VotingRights = require 'collections/voting_rights_collection'

module.exports = class IdeaThreads extends Collection
  model: IdeaThread
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
    idea_thread   = new IdeaThread(attributes)
    user_id       = Chaplin.mediator.user.get('id')
    voting_right  = idea_thread.userCanVote(user_id)

    if existing
      @handleExisting(existing, attributes, voting_right, idea_thread)
    else
      @add attributes if voting_right

  handleExisting: (existing, attributes, voting_right, idea_thread) ->
    if attributes.deleted or !voting_right
      @remove(existing)
    else
      rights = idea_thread.get('voting_rights').models
      existing.get('voting_rights').set(rights)
      # Setting attributes directly doesn't fire any change events
      # for the CollectionView, so I've got to manually set the
      # VotingRights' models and then set the threads's attrs

      attr = _.clone(idea_thread).attributes
      attr = _.omit attr, 'voting_rights' # remove from attributes
      existing.set(attr)
