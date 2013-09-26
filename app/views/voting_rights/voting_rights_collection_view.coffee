CollectionView = require 'views/base/collection-view'
VotingRight = require 'models/voting_right'
VotingRightView = require 'views/voting_rights/voting_right_view'
Groups          = require  'collections/groups_collection'
GroupsCollectionView = require 'views/groups/groups_collection_view'
template = require './templates/collection'

module.exports = class VotingRightsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  itemView: VotingRightView
  template: template
  listSelector: '.voting-rights'
  listen:
    'add collection': 'setThreadID'
    'add collection': 'updateGroupUI'
    'remove collection': 'updateGroupUI'
  events:
    'click .save-group': 'promptForGroupName'
    'submit .group-form': 'saveGroup'
    'click .show-groups': 'toggleGroups'

  initialize: (options) ->
    super
    @idea_thread = options.idea_thread
    @subscribeEvent 'saved_group', @cleanupGroupForm
    @setupGroups()

  render: ->
    super
    @$group_form = @$el.find('.group-form')
    @$group_form.hide()
    @updateGroupUI()

  initItemView: (model) ->
    new VotingRightView model: model, collection_view: @, idea_thread: @idea_thread

  setThreadID: (voting_right,b,c) ->
    unless @idea_thread.isNew()
      voting_right.set 'idea_thread_id', @idea_thread.get('id')
      voting_right.save()

  setupGroups: ->
    @groups = new Groups()
    @groups.on 'setVotingRights', (voting_rights) =>
      @toggleGroups()
      _.each voting_rights, (right) =>
        # add to collection unless it's in there already
        unless @collection.findWhere(right)
          @collection.add(right)

  promptForGroupName: (e) ->
    e.preventDefault()
    @$group_form.show()

    Mousetrap.bind 'esc', (e) =>
      @cleanupGroupForm()

  saveGroup: (e) ->
    e.preventDefault()
    e.stopPropagation()
    name = @$group_form.find('.group-name').val()
    @collection.saveAsGroup(name)

  cleanupGroupForm: (model) ->
    @$group_form.find('input').val()
    @$group_form.hide()
    Mousetrap.unbind('esc')
    @publishEvent 'reset_top_level_keys'

  updateGroupUI: ->
    $save_link = @$el.find('.save-group')
    if @collection.length > 1
      $save_link.show()
    else
      $save_link.hide()

  toggleGroups: (e) ->
    e.preventDefault() if e
    @$el.find('.show-groups').toggleClass('active')
    if !@subview('my_groups') or @subview('my_groups').disposed
      groups_view = new GroupsCollectionView
        collection: @groups
        container: @$el
      @subview 'my_groups', groups_view
    else
      @removeSubview('my_groups') if @subview('my_groups')

