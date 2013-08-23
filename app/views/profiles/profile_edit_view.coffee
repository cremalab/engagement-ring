template = require './templates/form'
View = require 'views/base/view'
DateInputView = require 'views/form_elements/date_input_view'

module.exports = class ProfileEditView extends View
  autoRender: true
  className: 'profileEdit'
  tagName: 'form'
  template: template
  events:
    "click button": 'save'

  render: ->
    super
    @subview 'employment_date', new DateInputView
      attr: 'employed_on'
      container: @$el.find("[for='employed_on']")

    @$el.find("[name='employed_on']").on 'keyup', (e) =>
      val = $(e.target).val()
      @model.set 'employed_on', val

  save: (e) ->
    e.preventDefault()
    @model.validate()
    # @model.save()