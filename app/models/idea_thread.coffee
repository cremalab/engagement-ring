Model = require '/models/base/model'
Idea  = require '/models/idea'
Vote = require '/models/vote'
IdeasCollection = require 'collections/ideas_collection'
VotesCollection = require 'collections/votes_collection'

module.exports = class IdeaThread extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/idea_threads')
  defaults:
    # ideas: new IdeasCollection()             # collection of IdeaVotes
    user_id: null

  initialize: ->
    super

    # else if @get('ideas').models is undefined
    #   console.log 'test'
    #   console.log @attributes
    #   alert 'ick'
    #   ideas = new IdeasCollection(@get('ideas'))
    #   @set 'ideas', ideas

  total_votes: ->
    ideas = @get('ideas')
    totals = ideas.pluck('total_votes')
    totals.reduce (memo, num) ->
      memo + num

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