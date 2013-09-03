View = require './view'

module.exports = class CollectionView extends Chaplin.CollectionView
  # This class doesn’t inherit from the application-specific View class,
  # so we need to borrow the method from the View prototype:
  getTemplateFunction: View::getTemplateFunction

  states:
    syncing:
      name: 'syncing'
    ready:
      name: 'ready'
  listen:
    'sync:start collection': 'startSync'
    'sync:end collection': 'clearState'

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
    super
    @current_user = Chaplin.mediator.user
  render: ->
    super
    @setState 'ready'
    @setupKeyBindings()

  viewForModel: (model) ->
    return @subview("itemView:" + model.cid)

  startSync: ->
    @setState 'syncing'

  clearState: ->
    @setState 'ready'

  setupKeyBindings: ->
    keys = _.keys @key_bindings
    collection_view = @
    _.each keys, (key) =>
      method = @key_bindings[key]
      Mousetrap.bind key, (e) ->
        collection_view[method]()