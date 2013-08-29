View = require 'views/base/view'

module.exports = class IdeaView extends View
  template: require './templates/show'

  events:
    'click .edit': 'edit'

  render: ->
    super
    console.log @model

  edit: (e) ->
    # e.preventDefaut()
    # console.log @model
    @publishEvent 'edit_idea', @model