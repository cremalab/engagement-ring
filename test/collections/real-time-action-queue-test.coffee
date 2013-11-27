Chaplin.mediator.apiURL = (path) ->
  "http://nowhere.local/#{path}"

RealTimeActionQueue = require 'collections/real_time_action_queue'
StreamState         = require 'models/stream_state'
NotifierStubs   = require 'test/lib/notifier_stubs'

describe 'RealTimeActionQueue', ->
  beforeEach ->
    Chaplin.mediator.stream_state           = new StreamState()
    Chaplin.mediator.real_time_action_queue = new RealTimeActionQueue()
    @queue = Chaplin.mediator.real_time_action_queue
    @action_stub =
      model_name: 'Test'
      mediator_event_name: 'test:publish'
      payload:
        test:
          success: true

  it 'should auto-fire events by default', ->
    @queue.subscribeEvent 'test:publish', (payload) ->
      expect(payload).to.not.be.empty
    @queue.add(@action_stub)
    expect(@queue.length).to.equal 0

  it "shouldn't fire events if StreamState is not live", ->
    Chaplin.mediator.stream_state.set('live', false)
    @queue.add(@action_stub)
    expect(@queue.length).to.equal 1
    expect(@queue.last().get('published')).to.be.false

  it "should fire all events when live is turned on", ->
    @queue.subscribeEvent 'test:publish', (payload) ->
      expect(payload).to.not.be.empty
    Chaplin.mediator.stream_state.set('live', false)
    @queue.add(@action_stub)
    @queue.add(@action_stub)
    expect(@queue.length).to.equal 2
    expect(@queue.last().get('published')).to.be.false
    Chaplin.mediator.stream_state.set('live', true)
    expect(@queue.length).to.equal 0