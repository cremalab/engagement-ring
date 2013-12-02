RealTimeAction = require 'models/real_time_action'


describe 'RealTimeAction', ->
  it 'should publish an event when fired', ->
    Chaplin.mediator.subscribe 'test:publish', (action) ->
      expect(action).to.be.a('object')
      expect(action.test.success).to.be.true
    action = new RealTimeAction
      model_name: 'Test'
      mediator_event_name: 'test:publish'
      payload:
        test:
          success: true
    expect(action.get('published')).to.be.false
    action.fire()
    expect(action.get('published')).to.be.true