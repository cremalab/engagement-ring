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
      model_name: 'Vote'
      mediator_event_name: 'test:publish'
      payload:
        test:
          success: true

  afterEach ->
    Chaplin.mediator.stream_state.setAll(true)
    Chaplin.mediator.real_time_action_queue.reset()

  it 'should auto-fire events by default', ->
    @queue.subscribeEvent 'test:publish', (payload) ->
      expect(payload).to.not.be.empty
    console.log 'add'
    @queue.add(@action_stub)
    expect(@queue.length).to.equal 0

  it "shouldn't fire events if StreamState is not live", ->
    stream_state = Chaplin.mediator.stream_state
    stream_state.setAll(false)
    expect(stream_state.get('Vote')).to.be.false
    @queue.add(@action_stub)
    expect(@queue.length).to.equal 1
    expect(@queue.last().get('published')).to.be.false

  it "should fire all events when live is turned on", ->
    @queue.subscribeEvent 'test:publish', (payload) ->
      expect(payload).to.not.be.empty
    Chaplin.mediator.stream_state.setAll(false)
    @queue.add(@action_stub)
    @queue.add(@action_stub)
    expect(@queue.length).to.equal 2
    expect(@queue.last().get('published')).to.be.false
    Chaplin.mediator.stream_state.setAll(true)
    expect(@queue.length).to.equal 0

  it "should not fire Votes if Votes are not live", ->
    Chaplin.mediator.stream_state.set('Vote', false)
    @queue.add(@action_stub)
    expect(@queue.length).to.equal 1
    Chaplin.mediator.stream_state.set('Vote', true)
    expect(@queue.length).to.equal 0

  it "should not fire IdeaThreads if IdeaThreads are not live", ->
    Chaplin.mediator.stream_state.set('IdeaThread', false)
    @queue.add({model_name: 'IdeaThread'})
    expect(@queue.length).to.equal 1
    Chaplin.mediator.stream_state.set('IdeaThread', true)
    expect(@queue.length).to.equal 0

  it "should not fire Ideas if Ideas are not live", ->
    Chaplin.mediator.stream_state.set('Idea', false)
    @queue.add({model_name: 'Idea'})
    expect(@queue.length).to.equal 1
    Chaplin.mediator.stream_state.set('Idea', true)
    expect(@queue.length).to.equal 0

  it "should not fire Comments if Comments are not live", ->
    Chaplin.mediator.stream_state.set('Comment', false)
    @queue.add({model_name: 'Comment'})
    expect(@queue.length).to.equal 1
    Chaplin.mediator.stream_state.set('Comment', true)
    expect(@queue.length).to.equal 0