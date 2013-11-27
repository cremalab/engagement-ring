Idea = require 'models/idea'
Ideas = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
IdeaThread = require 'models/idea_thread'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
Vote = require 'models/vote'
User = require 'models/user'
NotifierStubs = require 'test/lib/notifier_stubs'
VotingRights  = require 'collections/voting_rights_collection'
Application = require 'application'
SiteView = require 'views/site-view'
routes = require 'routes'


# Note! Many view methods are triggered by events from the Notifier class which
# passes along JSON from the Faye server. For tests, these are stubbed out in
# NotifierStubs - test/lib/notifier_stubs

describe 'IdeasCollectionView', ->
  new Application {
    title: 'Vot.io',
    controllerSuffix: '_controller',
    routes
  }
  new SiteView
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
      ideas: new Ideas

    @idea_thread.get('voting_rights').add
      autocomplete_search: "Ross Brown"
      autocomplete_value: @current_user.get('id')
      idea_thread_id: 1
      user_id: @current_user.get('id')

    @collection = new Ideas()


    @thread_view = new IdeaThreadView
      model: @idea_thread
      region: 'main'
      autoRender: true

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
    @view.newIdea()
    expect(@collection.size()).to.equal idea_count + 1

    # new idea should not have an id
    expect(@collection.last().get('id')).to.be.an('undefined')


  it 'should insert idea form on edit', ->
    @collection.add({id: 1, title: "Incorrect title"})
    model = @collection.last()
    model.set('edited', true)
    expect(@view.editing_view).to.exist
    expect(model.get('edited')).to.be.true
    expect(@view.editing_view.constructor.name).to.equal('IdeaEditView')

  it 'should unset edited property of idea on cancel', ->
    @collection.add({id: 1, title: "Incorrect title"})
    model = @collection.last()
    model.set('edited', true)
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




