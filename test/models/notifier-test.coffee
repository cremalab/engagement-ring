Notifier = require 'models/notifier'
User     = require 'models/group'
NotifierStubs = require '/test/lib/notifier_stubs'
IdeaThreadCollection = require 'collections/idea_threads_collection'
IdeasCollection = require 'collections/ideas_collection'

describe 'Notifier', ->
  beforeEach ->
    @notifier = new Notifier
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1

    # Create an IdeaThreadCollection to make sure user is
    # getting relevant notifications
    @threads = new IdeaThreadCollection()
    @threads.add NotifierStubs.idea_thread(1, 1)
    @thread = @threads.first()
    ideas = new IdeasCollection(@thread.get('ideas'))
    @thread.set('ideas', ideas)
    ideas = @thread.get('ideas')
    ideas.add(NotifierStubs.idea(1, @thread.get('id')))


  it 'should create a Web Notification', ->
    vote_stub = NotifierStubs.vote(1, 8, @thread.get('id'))
    web_notification = @notifier.createWebNotification("Vote", vote_stub)
    title = vote_stub.thread_title
    expect(web_notification.get('content').indexOf(title)).to.be.above -1

  it 'should not create a Web Notification if no access to thread', ->
    vote_stub = NotifierStubs.vote(20, 8, 15)
    web_notification = @notifier.createWebNotification("Vote", vote_stub)
    expect(web_notification).to.be.undefined

  it 'should not create a Web Notification if current_user did action', ->
    vote_stub = NotifierStubs.vote(1, Chaplin.mediator.user.get('id'), @thread.get('id'))
    web_notification = @notifier.createWebNotification("Vote", vote_stub)
    expect(web_notification).to.be.undefined
