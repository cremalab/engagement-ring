Chaplin.mediator.apiURL = (path) ->
  "http://nowhere.local/#{path}"

VotesCollection = require 'collections/votes_collection'
NotifierStubs   = require 'test/lib/notifier_stubs'
Idea     = require 'models/idea'
User     = require 'models/group'

describe 'VotesCollection', ->
  beforeEach ->
    @collection = new VotesCollection
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')
    @idea = new Idea
      title: "Lunch"
      description: "Delicious"
      user_id: @user_id
      id: 1
    @collection.idea = @idea

  it 'should add a vote from Faye event', ->
    vote = NotifierStubs.vote(1, @current_user.get('id'))
    @collection.updateVote(vote)
    expect(@collection.length).to.equal 1