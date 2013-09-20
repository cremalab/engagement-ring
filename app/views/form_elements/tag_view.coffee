View = require 'views/base/view'
Tag  = require 'models/tag'


module.exports = class TagView extends View

  autoRender: true
  attributes:
    'tag-list_tag' : ''
  events:
    'click .remove': 'removeItem'
  initialize: ->
    super
  removeItem: (e) ->
    e.preventDefault()
    @model.collection.remove @model