View = require 'views/base/view'
VotesCollection = require 'collections/votes_collection'
IdeasCollection = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
VotingRight = require 'models/voting_right'
VotingRights = require 'collections/voting_rights_collection'
VotingRightsView = require 'views/voting_rights/voting_rights_collection_view'
TagListInput = require 'views/form_elements/tag_list_input'
UserSearchCollection = require 'collections/user_search_collection'
IdeaThread = require 'models/idea_thread'

module.exports = class IdeaThreadView extends View
  template: require './templates/show'
  className: 'ideaThread'
  regions:
    ideas: '.ideas'
    voters: '.voters'
  textBindings: true
  listen:
    "change collection": "setOriginal"

  initialize: (options) ->
    super
    @collection_view = options.collection_view
    @ideas = @model.get('ideas')
    @setOriginal()

  setOriginal: ->
    @original_idea = @model.get('ideas').findWhere
      id: @model.get('original_idea_id')
    @original_idea.set 'original', true

  render: ->
    super
    @ideas_view = new IdeasCollectionView
      collection: @ideas
      region: 'ideas'
      thread_view: @
      original_idea: @original_idea
    @setupVotingRights()

  setupVotingRights: ->
    @voting_rights = @model.get('voting_rights')
    @all_users = new UserSearchCollection()
    @all_users.fetch()

    @model.set 'voting_rights', @voting_rights

    @voters_view = new VotingRightsView collection: @voting_rights, region: 'voters'

    profile_input = new TagListInput
      source_collection: @all_users
      collection: @voting_rights
      label: "Voters"
      attr: "id"
      tag_model: VotingRight
      tag_template: require('./templates/voter')
      existing_only: true
      container: @$el
      containerMethod: 'prepend'
    @subview('profile_input', profile_input)


  save: ->
    attrs = _.clone @model.attributes
    @publishEvent 'save_idea_thread', @model, @ideas, @collection_view, attrs
    @dispose()
