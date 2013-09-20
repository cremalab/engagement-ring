View = require 'views/base/form_view'

module.exports = module.exports = class DateInputView extends View
  className: 'profileEdit'
  tagName: 'input'
  attributes:
    type: 'datetime'
  events:
    'keyup': 'translateDate'

  initialize: (options) ->
    super
    @attribute = options.attr
    @model = options.model
  render: ->
    super
    @$el.attr('name', @attribute)

  translateDate: ->
    input_val = @$el.val()
    parsed = chrono.parse(input_val)
    if parsed.length > 0
      date = parsed[0]
      @model.set @attribute, date.startDate
    else
      if @model.get @attribute
        @model.set @attribute, null