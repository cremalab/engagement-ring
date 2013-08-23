View = require 'views/form_elements/base'

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
