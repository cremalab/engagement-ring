View = require 'views/base/form_view'

module.exports = class DateInputView extends View
  className: 'profileEdit'
  tagName: 'input'
  attributes:
    type: 'datetime'

  initialize: (options) ->
    super
    @attribute = options.attr
  render: ->
    super
    @$el.attr('name', @attribute)
