View = require 'views/base/view'
VotesCollection = require 'collections/votes_collection'
IdeasCollection = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
VotingRights = require 'collections/voting_rights_collection'
VotingRightsView = require 'views/voting_rights/voting_rights_collection_view'
TagListInput = require 'views/form_elements/tag_list_input'
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
    @profiles = new Chaplin.Collection()
    @all_users = new Chaplin.Collection([{name: 'Ross', autocomplete_search: 'Ross'}, {name: 'Rob', autocomplete_search: 'Rob'}, {name: 'Bill', autocomplete_search: 'Bill'}])

    @listenTo @profiles, 'add', =>
      console.log @profiles
      console.log 'added to profiles'

    profile_input = new TagListInput
      model: @model
      source_collection: @all_users
      collection: @profiles
      label: "Voters"
      attr: "name"
      full_name: true
      tag_template: require('./templates/voter')
      existing_only: true
      container: @$el
      containerMethod: 'prepend'
    @subview('profile_input', profile_input)



  save: ->
    attrs = _.clone @model.attributes
    @publishEvent 'save_idea_thread', @model, @ideas, @collection_view, attrs
    @dispose()
