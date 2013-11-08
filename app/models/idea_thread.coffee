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
    @subscribeEvent 'notifier:update_voting_right', @updateVotingRights

    if @isNew()
      current_user_id = Chaplin.mediator.user.get('id')
      ideas = new IdeasCollection()
      voting_rights = new VotingRightsCollection()
      voting_rights.add
        user_id: current_user_id
        autocomplete_value: current_user_id
      @set 'ideas', ideas
      @set 'voting_rights', voting_rights
    else
      if _.isArray(@get('voting_rights'))
        voting_rights = new VotingRightsCollection(@get('voting_rights'))
        @set 'voting_rights', voting_rights
      if _.isArray(@get('ideas'))
        ideas = new IdeasCollection(@get('ideas'))
        @set 'ideas', ideas


  updateVotingRights: (payload) ->
    if payload.deleted
      @get('voting_rights').remove(payload.id)


  total_votes: ->
    ideas = @get('ideas')
    if ideas.length > 0

      ideas_vote_totals = []
      ideas.each (idea) ->
        ideas_vote_totals.push idea.get('votes').length
      ideas_vote_totals.reduce (memo, num) ->
        memo + num
    else
      0

  isVotable: ->
    user_id = Chaplin.mediator.user.get('id')

    if @userCanVote(user_id)
      participant = true
    else
      participant = false

    if @get('status') is 'open'
      open = true
    else
      open = false

    return open and participant

  parse: (idea_thread) ->
    if idea_thread.ideas.length > 0
      ideas = idea_thread.ideas
      idea_thread.ideas = new IdeasCollection(ideas)
    else
      idea_thread.ideas = new IdeasCollection()
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
    _.extend json.idea_thread, {voting_rights_attributes: voting_rights}
    _.extend json.idea_thread, {ideas_attributes: ideas} if ideas.length
    return json

  userCanVote: (user_id) ->
    rights = @get 'voting_rights'
    right = rights.findWhere
      user_id: user_id
    return right
