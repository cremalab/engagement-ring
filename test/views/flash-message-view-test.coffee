FlashMessage = require 'models/flash_message'
FlashMessageView = require 'views/layout/flash_message_view'

describe 'FlashMessageView', ->
  beforeEach ->
    @flash = new FlashMessage(message: "I've lived a long and fulfilling life")
    @view = new FlashMessageView(model: @flash)

  it 'should self-destruct after its lifespan', ->
    expect(@view.state).to.equal('ready')
    lifespan = setTimeout =>
      expect(@flash.disposed).to.be.true
      clearTimeout(lifespan)
    , @flash.get('lifespan')

  it 'should dispose on dismissal', ->
    @view.$el.find('.dismiss').click()
    expect(@view.disposed).to.be.true
    expect(@flash.disposed).to.be.true