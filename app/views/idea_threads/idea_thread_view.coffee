View = require 'views/base/view'
VotesCollection = require 'collections/votes_collection'
IdeasCollection = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
VotingRight = require 'models/voting_right'
VotingRights = require 'collections/voting_rights_collection'
VotingRightsView = require 'views/voting_rights/voting_rights_collection_view'
TagListInput = require 'views/form_elements/tag_list_input'

module.exports = class IdeaThreadView extends View
  template: require './templates/show'
  className: 'ideaThread'
  regions:
    ideas: '.ideas'
    voters: '.voters'
  textBindings: true
  listen:
    "change collection": "setOriginal"
    'change': 'learn'
  learn: ->
    console.log @

  initialize: ->
    super
    @ideas = @model.get('ideas')
    @setOriginal()

  setOriginal: ->
    @original_idea = @ideas.findWhere
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
    console.log @voting_rights
    @all_users = new Chaplin.Collection([
      {name: 'Ross', autocomplete_search: 'Ross Brown', user_id: 1, autocomplete_value: 1},
      {name: 'Rob', autocomplete_search: 'Rob LaFeve', user_id:2, autocomplete_value: 2},
      {name: 'Bill', autocomplete_search: 'Bill Cool', user_id: 3, autocomplete_value: 3}
    ])

    @listenTo @voting_rights, 'add', =>
      console.log @voting_rights
      console.log 'added to profiles'

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
    @publishEvent 'save_idea_thread', @model, @ideas