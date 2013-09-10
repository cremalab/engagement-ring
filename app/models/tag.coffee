Model = require 'models/base/model'

module.exports = class Tag extends Model
  defaults:
    name: ""
    normalized_name: ""
  initialize: ->
    super
    @set 'normalized_name', @get('name').toLowerCase()
    @set('autocomplete_value', @get('name'))
    @set('autocomplete_search', @get('name'))