IdeaThread = require 'models/idea_thread'
User  = require 'models/group'

describe 'IdeaThread', ->
  beforeEach ->
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    Chaplin.mediator.apiURL = (path) ->
      "http://nowhere.local/#{path}"
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')

  it 'should calculate total votes', ->
    thread = new IdeaThread
    expect(thread.total_votes()).to.equal 0

    for i in [1..3] # Check across three ideas
      thread.get('ideas').add
        title: 'Good idea'
        user_id: @user_id
        id: 1

      idea = thread.get('ideas').last()

      # Add two votes per idea, for fun
      idea.get('votes').add
        user_id: @user_id
        idea_id: idea.get('id')
      idea.get('votes').add
        user_id: 2
        idea_id: idea.get('id')

      expect(thread.total_votes()).to.equal i + i

  it 'should create a voting_right for the creator', ->
    thread = new IdeaThread
    user_right = thread.get('voting_rights').findWhere
      user_id: @user_id
    expect(user_right).to.not.be.an('undefined')

  it 'should detect if user can vote', ->
    thread = new IdeaThread
    expect(thread.userCanVote(@user_id)).to.not.be.an('undefined')
    expect(thread.userCanVote(5000)).to.not.be.ok