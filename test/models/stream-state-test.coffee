StreamState = require 'models/stream_state'


describe 'StreamState', ->
  it 'should set all attributes with setAll', ->
    state = new StreamState
    expect(state.get('live')).to.equal.true
    expect(state.get('votes')).to.equal.true
    expect(state.get('comments')).to.equal.true
    expect(state.get('idea_threads')).to.equal.true
    expect(state.get('ideas')).to.equal.true

    state.setAll(false)

    expect(state.get('live')).to.equal.false
    expect(state.get('votes')).to.equal.false
    expect(state.get('comments')).to.equal.false
    expect(state.get('idea_threads')).to.equal.false
    expect(state.get('ideas')).to.equal.false

  it "should throw an error if setAll arg isn't boolean", ->
    state = new StreamState
    expect(-> state.setAll("I'm crazy!")).to.throw("StreamState values must be true or false")