Model = require '/models/base/model'
VotesCollection = require 'collections/votes_collection'
ActivitiesCollection = require 'collections/activities_collection'
Comments = require 'collections/comments_collection'

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
    # Setup Votes Collection
    votes = new VotesCollection(@get 'votes')
    votes.idea = @
    @set 'votes', votes

    # Setup Comments collection
    comments = new Comments(@get('comments'), idea: @)
    @set('comments', comments)

    # ActivitiesCollection arguements: Items, Idea, Collection Limit
    activities = new ActivitiesCollection(@get('recent_activities'), @, 10)
    @set 'recent_activities', activities

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

  performUserVote: (idea_thread) ->
    if idea_thread.isVotable()
      @get('votes').voteOnIdea(@get('id'))
    else
      if idea_thread.get('status') is 'archived'
        @publishEvent 'flash_message', "Voting on #{idea_thread.get('title')} is closed"
      else
        @publishEvent 'flash_message', "You don't have permission to vote on this topic"

  parse: (idea) ->
    # ActivitiesCollection arguements: Items, Idea, Collection Limit
    activities = new ActivitiesCollection(idea.recent_activities, @, 10)
    idea.recent_activities = activities
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