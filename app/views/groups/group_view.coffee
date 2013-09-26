View = require 'views/base/view'

module.exports = class GroupView extends View
  template: require './templates/show'
  events:
    'click .add-group': 'addGroup'

  addGroup: (e) ->
    e.preventDefault()
    rights = @model.prepareVotingRights()
    if @collection_view
      @collection_view.collection.trigger('setVotingRights', rights)
