View = require 'views/base/view'

module.exports = class IdeaView extends View
  template: require './templates/show'
  className: 'idea'
  events:
    'click .edit': 'edit'

  edit: (e) ->
    # e.preventDefaut()
    # console.log @model
    @publishEvent 'edit_idea', @model
