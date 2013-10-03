View = require 'views/base/view'
template = require './templates/show'

module.exports = class MembershipView extends View
  template: template
  autoRender: true
  autoAttach: true
  events:
    'click .remove': 'removeMembership'

  removeMembership: (e) ->
    e.preventDefault()
    @model.destroy()