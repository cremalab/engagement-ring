Chaplin.mediator.apiURL = (path) ->
  "http://nowhere.local/#{path}"

Comments = require 'collections/comments_collection'
NotifierStubs   = require 'test/lib/notifier_stubs'
Idea     = require 'models/idea'
Comment  = require 'models/comment'
User     = require 'models/user'

describe 'CommentsCollection', ->
  beforeEach ->
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
      profile:
        first_name: "Ross"
        last_name: "Brown"
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')

    @idea = new Idea
      title: "Lunch"
      description: "Delicious"
      user_id: @user_id
      id: 1
    @collection = new Comments([], idea_id: 1)

  it 'should add a comment from Faye event', ->
    expect(@collection.length).to.equal 0
    comment = NotifierStubs.comment(1, 2)
    Chaplin.mediator.publish("notifier:update_comment", comment)
    expect(@collection.length).to.equal 1

  it 'should not add a comment from another idea', ->
    non_idea_comment = NotifierStubs.comment(50, 2)
    Chaplin.mediator.publish("notifier:update_comment", non_idea_comment)
    expect(@collection.length).to.equal 0