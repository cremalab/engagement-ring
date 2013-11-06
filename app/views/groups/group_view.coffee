View = require 'views/base/view'
Membership = require 'models/membership'
MembershipsView = require 'views/memberships/memberships_collection_view'
TagListInput = require 'views/form_elements/tag_list_input'
UserSearchCollection = require 'collections/user_search_collection'

module.exports = class GroupView extends View
  events:
    'click .add-group': 'addGroup'
    'click .destroy'  : 'destroy'
    'click .save': 'saveGroup'

  initialize: (options) ->
    @template = options.template
    super

  addGroup: (e) ->
    e.preventDefault()
    rights = @model.prepareVotingRights()
    if @collection_view
      @collection_view.collection.trigger('setVotingRights', rights)

  render: ->
    super
    @memberships = @model.get('memberships')
    memberships_view = new MembershipsView
      collection: @memberships
      el: @$el.find('.members')

    @subview('memberships', memberships_view)
    @setupMembershipForm()

  destroy: (e) ->
    e.preventDefault()
    @model.destroy()

  setupMembershipForm: ->
    @all_users = new UserSearchCollection()
    @all_users.fetch()

    profile_input = new TagListInput
      destination_model: @model
      source_collection: @all_users
      collection: @memberships
      label: "Members"
      attr: "id"
      tag_model: Membership
      tag_template: require('/views/idea_threads/templates/voter')
      existing_only: true
      el: @$el.find('.add-members')
    @subview('profile_input', profile_input)

    @memberships.on 'add', =>
      @saveGroup()

  saveGroup: (e) ->
    e.preventDefault() if e
    @model.set('memberships', @memberships)
    @model.save()
