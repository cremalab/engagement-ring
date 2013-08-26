View = require './view'
ErrorsCollection = require 'collections/errors_collection'
ErrorsView = require 'views/form_elements/errors/collection_view'
Error = require 'models/error'

module.exports = class FormView extends View
  autoRender: true
  regions:
    'errors': '.errors'
  states:
    invalid:
      name: 'invalid'
    syncing:
      name: 'syncing'
    ready:
      name: 'ready'
  listen:
    'sync:start model': 'startSync'
    'sync:end model': 'clearState'

  initialize: ->
    super
    @errors = new ErrorsCollection()
    @subscribeEvent 'renderError', @renderError
  setState: (state) ->
    console.log 'setting state to ' + state
    _.each _.keys @states, (state) ->
      @$el.removeClass(state)
    name = @states[state]['name']
    @$el.addClass name
    @state = name
  state: ->
    return @state
  render: ->
    super
    if @model
      @modelBinder = new Backbone.ModelBinder()
      @modelBinder.bind @model, @$el
      @model.on "invalid", (model, error) =>
        console.log error
        @renderError(error)

  startSync: ->
    @setState 'syncing'

  clearState: ->
    @setState 'ready'

  renderError: (error, model) ->
    @errors.reset()
    @errors_view = new ErrorsView collection: @errors, el: @$el.find('.errors'), autoRender: true
    @$el.find('button').removeAttr('disabled', true)
    if typeof error is 'object'
      errorJSON = $.parseJSON(error.responseText)
      for error in errorJSON
        errorObj =
          text: error
        @errros.add(errorObj)
    else
      errorObj =
        text: error
      @errors.add(errorObj)