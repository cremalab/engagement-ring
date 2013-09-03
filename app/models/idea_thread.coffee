Model = require '/models/base/model'
IdeasCollection = require 'collections/ideas_collection'

module.exports = class IdeaThread extends Model
  urlRoot: 'http://localhost:3000/idea_threads'
  defaults:
    ideas: new IdeasCollection()             # collection of IdeaVotes
    user_id: null

  parse: (idea_thread) ->
    ideas = idea_thread.ideas
    idea_thread.ideas = new IdeasCollection(ideas)
    return idea_thread

  toJSON: ->
    ideas = this.get('ideas').toJSON()
    ideas = _.pluck(ideas, 'idea')
    new_attr = _.clone(this.attributes)
    delete new_attr.ideas
    json = {idea_thread : new_attr}
    _.extend json.idea_thread, {ideas_attributes: ideas}
    return json