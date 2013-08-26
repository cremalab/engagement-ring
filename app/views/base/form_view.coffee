View = require './view'

module.exports = class FormView extends View
  autoRender: true
  states:
    invalid:
      name: 'invalid'
    syncing:
      name: 'syncing'

  setState: (state) ->
    _.each _.keys @states, (state) ->
      @$el.removeClass(state)
    name = @states[state]['name']
    @$el.addClass name
    @state = name
  state: ->
    return @state
  render: ->
    super
    @modelBinder = new Backbone.ModelBinder()
    @modelBinder.bind @model, @$el