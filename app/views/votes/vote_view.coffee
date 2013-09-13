View = require 'views/base/view'
User = require 'models/user'

module.exports = class VoteView extends View
  template: require './templates/show'
  autoRender: true
  autoAttach: true
  className: "tooltip avatar"
  events:
    'click .revoke': 'revoke'

  revoke: ->
    @model.destroy()
  render: ->
    super
    user = new User(@model.get('user'))
    console.log user
    @$el.attr('data-tooltip', user.display_name())
