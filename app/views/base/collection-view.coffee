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
  render: ->
    super
    @setState 'ready'

  startSync: ->
    @setState 'syncing'

  clearState: ->
    @setState 'ready'