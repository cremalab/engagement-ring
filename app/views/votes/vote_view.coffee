View = require 'views/base/view'

module.exports = class VoteView extends View
  template: require './templates/show'
  autoRender: true
  autoAttach: true
  events:
    'click .revoke': 'revoke'

  revoke: ->
    @model.destroy()
