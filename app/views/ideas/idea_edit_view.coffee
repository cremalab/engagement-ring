View = require 'views/base/form_view'

module.exports = class IdeaEditView extends View
  template: require './templates/edit'

  render: ->
    super
    @$el.find('.plain-english').on 'keyup', (e) =>
      val = $(e.target).val()
      @translateDate(val)

  translateDate: (input_val) ->
    parsed = chrono.parse(input_val)
    if parsed.length > 0
      date = parsed[0]
      @model.set 'when', date.startDate
      title = date.concordance.replace(date.text, '').replace('  ', ' ')
      @model.set('title', title)
      @$el.find('.when').text moment(date.startDate).format("dddd MMM D, ha")
    else
      @model.set('title', input_val)
      if @model.get 'when'
        @model.set 'when', null