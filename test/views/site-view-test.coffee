SiteView = require 'views/site-view'

describe 'SiteView', ->
  beforeEach ->
    @view = new SiteView()

  it 'should render flash messages on mediator event', ->
    message = "HEY LOOK AT ME!!!"
    Chaplin.mediator.publish 'flash_message', message
    expect(@view.flashMessage.get('message')).to.equal(message)

