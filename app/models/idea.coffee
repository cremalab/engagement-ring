Model = require '/models/base/model'
IdeaVotesCollection = require 'collections/votes_collection'

module.exports = class Idea extends Model
  urlRoot: 'http://localhost:3000/ideas'
  paramRoot: 'idea'
  defaults:
    title: null           # string, validates_presence_of
    description: null
    when: null            # datetime, allow nil
    votes: new IdeaVotesCollection()             # collection of IdeaVotes
    user_id: null

  parse: (idea) ->
    votes = idea.votes
    idea.votes = new IdeaVotesCollection(votes)
    return idea

  toJSON: ->
    new_attr = _.clone(this.attributes)
    delete new_attr.votes
    json = {idea : new_attr}
    _.extend json.idea, {votes_attributes: this.get("votes").toJSON()}
    return json

  validate: ->
    if @get('title') is '' or @get('title') is null
      return "Title can't be blank"