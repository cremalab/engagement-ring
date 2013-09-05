Idea = require 'models/idea'
Ideas = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
IdeaThread = require 'models/idea_thread'
IdeaThreadView = require 'views/idea_threads/idea_thread_view'
Vote = require 'models/vote'
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

    @first_idea = new Idea
      title: 'Newest Idea'
      description: 'fresh'
      user_id: @user_id
      id: 1

    @second_idea = new Idea
      title: 'Pancakes for lunch'
      description: 'with blueberries on top'
      user_id: @user_id
      id: 2
      votes: []

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

  it 'should vote for new alternate ideas a user creates', ->

    @collection.add @first_idea

    @first_idea.get('votes').add
      user_id: @user_id
      idea_id: 1

    @collection.add @second_idea

    @second_idea.get('votes').add
      user_id: @user_id
      idea_id: 2

    Chaplin.mediator.publish('saved_idea', @first_idea, @collection)
    expect(@first_idea.get('votes').length).to.equal 0
    expect(@first_idea.get('votes').length).to.equal > 0

  it 'should only allow one vote per collection', ->
    @collection.add @first_idea
    @first_idea.get('votes').add
      user_id: @user_id
      idea_id: 1
    expect(@first_idea.get('votes').length).to.equal 1

    @collection.add @second_idea
    new_vote = new Vote
      user_id: @user_id
      idea_id: 2
    @second_idea.get('votes').add(new_vote)

    Chaplin.mediator.publish 'vote', new_vote, @second_idea
    expect(@first_idea.get('votes').length).to.equal 0
    expect(@view.currentUserVote().get('idea_id')).to.equal(2)
    expect(@view.currentUserVotedIdea()).to.equal @second_idea