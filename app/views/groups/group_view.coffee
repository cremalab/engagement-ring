View = require 'views/base/view'
MembershipsView = require 'views/memberships/memberships_collection_view'

module.exports = class GroupView extends View
  events:
    'click .add-group': 'addGroup'
    'click .destroy'  : 'destroy'

  initialize: ->
    @template = @options.template
    super
  addGroup: (e) ->
    e.preventDefault()
    rights = @model.prepareVotingRights()
    if @collection_view
      @collection_view.collection.trigger('setVotingRights', rights)

  render: ->
    super
    console.log @model.get 'memberships'
    memberships_view = new MembershipsView
      collection: @model.get('memberships')
      el: @$el.find('.members')
    @subview('memberships', memberships_view)

  destroy: (e) ->
    e.preventDefault()
    @model.destroy()