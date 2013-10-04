Notifier = require 'models/notifier'
User     = require 'models/group'
NotifierStubs = require '/test/lib/notifier_stubs'

describe 'Notifier', ->
  beforeEach ->
    @notifier = new Notifier
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1

  it 'should create a Web Notification', ->
    vote_stub = NotifierStubs.vote(1, 2)
    web_notification = @notifier.createWebNotification("Vote", vote_stub)
    title = vote_stub.thread_title
    expect(web_notification.get('content').indexOf(title)).to.be.above -1

  it 'should not create a Web Notification if current_user did action', ->
    vote_stub = NotifierStubs.vote(1, Chaplin.mediator.user.get('id'))
    web_notification = @notifier.createWebNotification("Vote", vote_stub)
    expect(web_notification).to.be.undefined