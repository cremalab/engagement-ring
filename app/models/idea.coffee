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
    # votes: new IdeaVotesCollection()             # collection of IdeaVotes
    user_id: null

  initialize: ->
    super
    @set 'votes', new VotesCollection(@get 'votes')

  parse: (idea) ->
    votes = idea.votes
    idea.votes = new VotesCollection(votes)
    return idea

  toJSON: ->
    votes = this.get('votes').toJSON()
    console.log "TO JSON VOTES"
    console.log votes
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