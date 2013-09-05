Idea = require 'models/idea'
Ideas = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
IdeaThread = require 'models/idea_thread'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
User = require 'models/user'

describe 'IdeasCollectionView', ->
  beforeEach ->
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')

    @idea_thread = new IdeaThread
      user_id: 1
      id: 1

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

  it 'should add ideas', ->
    idea_count = @view.collection.size()
    @view.addIdea()
    expect(@view.collection.size()).to.equal idea_count + 1
    expect(@view.$el.find("[name='title']").length).to.equal 1
    expect(@view.$el.find("[name='description']").length).to.equal 1
    expect(@view.$el.find("[name='when']").length).to.equal 1

  it 'should only allow one vote per collection', ->
    idea = new Idea
      title: 'Newest Idea'
      description: 'fresh'
      user_id: @user_id
      id: 1
    idea.get('votes').add
      user_id: @user_id
      idea_id: 1
    @collection.add idea

    expect(@view.currentUserVote()).to.be.a('object')
    expect(@view.currentUserVote().get('user_id')).to.equal @user_id
    expect(@view.currentUserVote().get('idea_id')).to.equal 1

    new_idea = new Idea
      title: 'Pancakes for lunch'
      description: 'with blueberries on top'
      user_id: @user_id
      id: 2
      votes: []
    new_idea.get('votes').add
      user_id: @user_id
      idea_id: 1

    @collection.add new_idea

    @view.save(new_idea)
    Chaplin.mediator.publish('saved_idea', new_idea, @collection)
    expect(idea.get('votes').length).to.equal 0
    expect(new_idea.get('votes').length).to.equal > 0