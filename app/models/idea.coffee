Model = require '/models/base/model'
VotesCollection = require 'collections/votes_collection'

module.exports = class Idea extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/ideas')
  paramRoot: 'idea'
  defaults:
    title: null           # string, validates_presence_of
    description: null
    when: null            # datetime, allow nil
    user_id: null

  initialize: ->
    super
    votes = new VotesCollection(@get 'votes')
    votes.idea = @
    @set 'votes', votes
    @listenTo @, 'change:updated_at', =>
      @set 'edited', false

  hasVote: (vote_id) ->
    votes = @get('votes')
    existing = votes.findWhere
      id: vote_id
    if existing
      return true
    else
      return false

  parse: (idea) ->
    votes = idea.votes
    votes = new VotesCollection(votes)
    votes.idea = @
    idea.votes = votes
    return idea

  toJSON: ->
    votes = this.get('votes').toJSON()
    new_attr = _.clone(this.attributes)
    delete new_attr.votes
    json = {idea : new_attr}
    _.extend json.idea, {votes_attributes: votes}
    return json

  save: ->
    @unset 'original'
    super

  validate: ->
    if @get('title') is '' or @get('title') is null
      return "Title can't be blank"