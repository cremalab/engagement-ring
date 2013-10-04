Chaplin.mediator.apiURL = (path) ->
  "http://nowhere.local/#{path}"
IdeaThreadsCollection = require 'collections/idea_threads_collection'
User     = require 'models/group'

describe 'IdeaThreadsCollection', ->
  beforeEach ->
    @collection = new IdeaThreadsCollection
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')

  it 'should find a thread', ->
    thread =
      "id":420
      "title":"Stuff"
      "user_id":3
      "status":"open"
      "original_idea_id":698
      "ideas":[
        "id":698,"title":"NEW"
        "description":""
        "when":null
        "idea_thread_id":420
        "user_id":3
        "total_votes":2
        "user":
          "email":"ross@cremalab.com"
          "id":3
          "profile":
            "first_name":"Ross"
            "last_name":"Brown"
        "original":true
        "votes":[
          "idea_id":698
          "user_id":3
          "id":1772
          "thread_id":420
        ]
      ]
    @collection.add(thread)
    Chaplin.mediator.publish 'find_thread', 420, (thread) ->
      expect(thread).to.not.be.undefined
      expect(thread.id).to.equal 420