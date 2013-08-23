View = require 'views/base/view'

module.exports = class BaseFormElementView extends View
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