Chaplin.mediator.apiURL = (path) ->
  "http://nowhere.local/#{path}"
IdeasCollection = require 'collections/ideas_collection'
NotifierStubs   = require 'test/lib/notifier_stubs'
User     = require 'models/group'

describe 'IdeasCollection', ->
  beforeEach ->
    @collection = new IdeasCollection
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')

  it 'should add idea on faye event', ->
    idea_count = @collection.size()
    notifier = NotifierStubs.idea(1, @collection.thread_id)
    @collection.updateIdeas(notifier)
    expect(@collection.size()).to.equal idea_count + 1

  it "should not add idea if idea doesn't belong", ->
    idea_count = @collection.size()
    notifier = NotifierStubs.idea(2, 500)

    @collection.updateIdeas(notifier)
    expect(@collection.size()).to.equal idea_count

  it 'should update idea on faye event', ->
    notifier = NotifierStubs.idea(1, @collection.thread_id)
    @collection.updateIdeas(notifier)
    idea_count = @collection.size()
    notifier['title'] = 'Boogaloo'
    @collection.updateIdeas(notifier)

    expect(@collection.size()).to.equal idea_count
    match = @collection.findWhere
      title: notifier['title']
    expect(match).to.exist

  it 'should remove idea on faye event', ->
    @collection.add({id: 1, title: "Goodbye cruel world!"})
    idea_count = @collection.size()

    notifier = NotifierStubs.deleted_idea(1, @collection.thread_id)

    @collection.updateIdeas(notifier)
    expect(@collection.size()).to.equal idea_count - 1