Model = require '/models/base/model'
IdeaVotesCollection = require 'collections/idea_votes_collection'

module.exports = class Idea extends Model
  urlRoot: '/ideas'
  defaults:
    created_by: null      # fk: user_id, validates_presence_of
    title: null           # string, validates_presence_of
    when: null            # datetime, allow nil
    idea_votes: []        # collection of IdeaVotes
    created_at: null      # datetime
    updated_at: null      # datetime

  initialize: ->
    console.log @
    @set 'idea_votes', new IdeaVotesCollection(@idea_votes)

  parse: (idea) ->
    votes = idea.idea_votes
    idea.idea_votes = new IdeaVotesCollection(votes)