StreamState = require 'models/stream_state'


describe 'StreamState', ->
  beforeEach ->
    @state = new StreamState
  afterEach ->
    @state.dispose()

  it 'should set all attributes with setAll', ->
    expect(@state.get('Vote')).to.equal.true
    expect(@state.get('Comment')).to.equal.true
    expect(@state.get('IdeaThread')).to.equal.true
    expect(@state.get('Idea')).to.equal.true

    @state.setAll(false)

    expect(@state.get('Vote')).to.equal.false
    expect(@state.get('Comment')).to.equal.false
    expect(@state.get('IdeaThread')).to.equal.false
    expect(@state.get('Idea')).to.equal.false

  it "should throw an error if setAll arg isn't boolean", ->
    @state = new StreamState
    expect(=> @state.setAll("I'm crazy!")).to.throw("StreamState values must be true or false")