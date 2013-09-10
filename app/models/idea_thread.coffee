Model = require '/models/base/model'
Idea  = require '/models/idea'
Vote = require '/models/vote'
IdeasCollection = require 'collections/ideas_collection'
VotesCollection = require 'collections/votes_collection'
VotingRightsCollection = require 'collections/voting_rights_collection'

module.exports = class IdeaThread extends Model
  urlRoot: ->
    Chaplin.mediator.apiURL('/idea_threads')
  defaults:
    # ideas: new IdeasCollection()             # collection of IdeaVotes
    user_id: null

  initialize: ->
    super
    if @isNew()
      current_user_id = Chaplin.mediator.user.get('id')
      ideas = new IdeasCollection()
      voting_rights = new VotingRightsCollection()
      voting_rights.add
        user_id: current_user_id
        autocomplete_value: current_user_id
      vote = new Vote
      idea = new Idea
        user_id: current_user_id
      idea.get('votes').add
        user_id: current_user_id
      ideas.add(idea)
      @set 'ideas', ideas
      @set 'voting_rights', voting_rights

  total_votes: ->
    ideas = @get('ideas')
    totals = ideas.pluck('total_votes')
    totals.reduce (memo, num) ->
      memo + num

  parse: (idea_thread) ->
    ideas = idea_thread.ideas
    idea_thread.ideas = new IdeasCollection(ideas)
    voting_rights = idea_thread.voting_rights
    idea_thread.voting_rights = new VotingRightsCollection(voting_rights)
    return idea_thread

  toJSON: ->
    ideas = this.get('ideas').toJSON()
    ideas = _.pluck(ideas, 'idea')
    voting_rights = this.get('voting_rights').toJSON()
    new_attr = _.clone(this.attributes)
    delete new_attr.ideas
    delete new_attr.voting_rights
    json = {idea_thread : new_attr}
    _.extend json.idea_thread, {ideas_attributes: ideas, voting_rights_attributes: voting_rights}
    return json