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

  initialize: ->
    @hot_keys = _.keys @key_bindings
  render: ->
    @setState 'ready'
    super
    @setupKeyBindings()

  setupKeyBindings: ->
    collection_view = @
    _.each @hot_keys, (key) =>
      method = @key_bindings[key]
      if key is 'enter'
        event_time = 'keyup'
      Mousetrap.bind key, (e) ->
        collection_view[method]()
      , event_time

  dispose: ->
    super
    _.each @hot_keys, (key) ->
      Mousetrap.unbind key