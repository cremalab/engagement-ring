View = require 'views/base/view'

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

  destroy: (e) ->
    e.preventDefault()
    @model.destroy()