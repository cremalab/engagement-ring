require 'lib/view-helper' # Just load the view helpers, no return value

module.exports = class View extends Chaplin.View
  states:
    ready:
      name: 'ready'

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    @template

  setState: (state) ->
    console.log "setting state of #{@constructor.name} #{@cid} to #{state}"
    _.each _.keys @states, (state) ->
      @$el.removeClass(state)
    name = @states[state]['name']
    @$el.addClass name
    @state = name
  state: ->
    return @state
  render: ->
    super
    @setState 'ready'