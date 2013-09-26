CollectionView = require 'views/base/collection-view'
VotingRight = require 'models/voting_right'
VotingRightView = require 'views/voting_rights/voting_right_view'
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
  events:
    'click .save-group': 'promptForGroupName'
    'submit .group-form': 'saveGroup'

  initialize: (options) ->
    super
    @idea_thread = options.idea_thread

  render: ->
    super
    @$group_form = @$el.find('.group-form')
    @$group_form.hide()

  initItemView: (model) ->
    new VotingRightView model: model, collection_view: @, idea_thread: @idea_thread

  setThreadID: (voting_right,b,c) ->
    unless @idea_thread.isNew()
      voting_right.set 'idea_thread_id', @idea_thread.get('id')
      voting_right.save()

  promptForGroupName: (e) ->
    e.preventDefault()
    @$group_form.show()

  saveGroup: (e) ->
    e.preventDefault()
    e.stopPropagation()

    console.log @collection
    @collection.saveAsGroup()