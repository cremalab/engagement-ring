require 'lib/view-helper' # Just load the view helpers, no return value

module.exports = class View extends Chaplin.View
  states:
    ready:
      name: 'ready'
  listen:
    'change model': 'updateView'

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    @template

  setState: (state) ->
    # console.log "setting state of #{@constructor.name} #{@cid} to #{state}"
    _.each _.keys @states, (state) ->
      @$el.removeClass(state)
    name = @states[state]['name']
    @$el.addClass name
    @state = name
  state: ->
    return @state

  initialize: (options) ->
    super
    @hot_keys = _.keys @key_bindings
    @current_user = Chaplin.mediator.user
    @collection_view = options.collection_view if options and options.collection_view
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


  updateView: (model) ->
    if @textBindings
      attributes = _.keys model.changed
      _.each attributes, (attr) =>
        $el = @$el.find("[data-bind='#{attr}']:first").not(".ideaTitle span") # eew
        if $el.length
          if @model.get(attr) is undefined
            $el.text ''
          else
            $el.text @model.get(attr)