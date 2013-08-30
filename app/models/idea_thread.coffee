Model = require '/models/base/model'
IdeasCollection = require 'collections/ideas_collection'

module.exports = class IdeaThread extends Model
  urlRoot: 'http://localhost:3000/idea_threads'
  defaults:
    title: null           # string, validates_presence_of
    description: null
    when: null            # datetime, allow nil
    ideas: new IdeasCollection()             # collection of IdeaVotes
    user_id: null

  # parse: (idea) ->
  #   votes = idea.votes
  #   idea.votes = new IdeaVotesCollection(votes)
  #   return idea

  # toJSON: ->
  #   new_attr = _.clone(this.attributes)
  #   delete new_attr.votes
  #   json = {idea : new_attr}
  #   _.extend json.idea, {votes_attributes: this.get("votes").toJSON()}
  #   return json