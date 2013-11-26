Collection = require 'models/base/collection'
Idea = require 'models/idea'

module.exports = class Ideas extends Collection
  model: Idea
  urlRoot: ->
    Chaplin.mediator.apiURL('/ideas')
  comparator: (idea) ->
    return idea.get('total_votes') * -1

  initialize: (options) ->
    super
    @subscribeEvent 'saved_idea', @updateModel
    @subscribeEvent 'notifier:update_idea', @updateIdeas

  updateModel: (model) ->
    user_id = model.get 'user_id'
    vote = model.get('votes').findWhere
      user_id: user_id

    @find(model).set(model.attributes)
    @publishEvent 'edit_idea', model

  updateIdeas: (data) ->
    if data.deleted
      @remove(data.id)
    else
      @addIdea(data) if data.idea_thread_id == @thread_id

  addIdea: (data) ->
    existing = @findWhere
      id: data.id
    if existing
      data = _.pick(data, ['title', 'description', 'expiration', 'description'])
      existing.set data
      @updateModel existing
    else
      @add data