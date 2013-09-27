Idea = require 'models/idea'
Ideas = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
IdeaThread = require 'models/idea_thread'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
Vote = require 'models/vote'
User = require 'models/user'
NotifierStubs = require 'test/lib/notifier_stubs'
VotingRights  = require 'collections/voting_rights_collection'


# Note! Many view methods are triggered by events from the Notifier class which
# passes along JSON from the Faye server. For tests, these are stubbed out in
# NotifierStubs - test/lib/notifier_stubs

describe 'IdeasCollectionView', ->
  beforeEach ->
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    Chaplin.mediator.apiURL = (path) ->
      "http://nowhere.local/#{path}"
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')

    @idea_thread = new IdeaThread
      user_id: 1
      id: 1
      voting_rights: new VotingRights

    @idea_thread.get('voting_rights').add
      autocomplete_search: "Ross Brown"
      autocomplete_value: @current_user.get('id')
      idea_thread_id: 1
      user_id: @current_user.get('id')

    @thread_view = new IdeaThreadView
      model: @idea_thread

    @collection = new Ideas
    @view = new IdeasCollectionView
      collection: @collection
      region: 'ideas'
      thread_view: @thread_view

  afterEach ->
    @view.dispose()
    @thread_view.dispose()


  it 'should add idea on click of button', ->
    idea_count = @collection.size()
    @view.$el.find('.ideate').click()
    expect(@collection.size()).to.equal idea_count + 1

    # new idea should not have an id
    expect(@collection.last().get('id')).to.be.an('undefined')

  it 'should add idea on faye event', ->
    idea_count = @collection.size()
    notifier = NotifierStubs.idea(1, @view.thread_id)

    @view.addIdea(notifier)
    expect(@collection.size()).to.equal idea_count + 1

  it 'should update idea on faye event', ->
    notifier = NotifierStubs.idea(1, @view.thread_id)
    @view.addIdea(notifier)
    idea_count = @collection.size()
    notifier['title'] = 'Boogaloo'
    @view.addIdea(notifier)

    expect(@collection.size()).to.equal idea_count
    re = new RegExp("\\b(" + notifier['title'] + ")\\b", 'ig')
    expect(@view.$el.text()).to.match(re)


  it 'should remove idea on faye event', ->
    @collection.add({id: 1, title: "Goodbye cruel world!"})
    idea_count = @collection.size()

    notifier = NotifierStubs.deleted_idea(1, @view.thread_id)

    @view.addIdea(notifier)
    expect(@collection.size()).to.equal idea_count - 1

  it 'should insert idea form on edit', ->
    @collection.add({id: 1, title: "Incorrect title"})
    model = @collection.last()
    @view.editIdea(model)
    expect(@view.editing_view).to.exist
    expect(model.get('edited')).to.be.true
    expect(@view.editing_view.constructor.name).to.equal('IdeaEditView')

  it 'should unset edited property of idea on cancel', ->
    @collection.add({id: 1, title: "Incorrect title"})
    model = @collection.last()
    @view.editIdea(model)
    expect(model.get('edited')).to.be.true
    @view.$el.find('.cancel').click()
    expect(model.get('edited')).to.be.a('undefined')
    expect(@view.editing_view).to.not.be.ok

  it 'should render edit view if model is new', ->
    @collection.add({title: "Incorrect title"})
    model = @collection.last()
    expect(@view.viewForModel(model).constructor.name).to.equal('IdeaEditView')

  it 'should render show view if model has ID', ->
    @collection.add({id: 1, title: "Incorrect title"})
    model = @collection.last()
    expect(@view.viewForModel(model).constructor.name).to.equal('IdeaView')

  it 'should add user vote from faye event', ->
    @collection.add({id: 1, title: "Cool idea"})
    expect(@collection.last().get('votes').length).to.equal 0
    vote = NotifierStubs.vote(1, @current_user.get('id'))
    @view.updateVote(vote)
    expect(@collection.last().get('votes').length).to.equal 1

  it 'should reassign user vote when adding idea', ->
    idea_stub = NotifierStubs.idea(1, @view.thread_id)
    _.extend idea_stub, {votes: [{user_id: @current_user.get('id'), idea_id: 1, id:1}]}
    @view.addIdea(idea_stub)
    idea = @collection.last()

    expect(idea.get('votes').length).to.equal 1

    idea_stub['title'] = "Better idea"
    idea_stub['id']    = 2
    _.extend idea_stub, {votes: [{user_id: @current_user.get('id'), idea_id: 2, id: 2}]}

    @view.addIdea(idea_stub)
    second_idea = @collection.last()

    expect(idea.get('votes').length).to.equal 0
    expect(second_idea.get('votes').length).to.equal 1



