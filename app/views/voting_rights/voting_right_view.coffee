View = require 'views/base/view'

module.exports = class VotingRightView extends View
  template: require './templates/show'
  autoRender: true
  autoAttach: true
  events:
    'click .remove': 'removeItem'
  initialize: (options) ->
    super
    @model.set 'thread_user_id', options.idea_thread.get('user_id')
  removeItem: (e) ->
    e.preventDefault()
    @model.collection.remove @model