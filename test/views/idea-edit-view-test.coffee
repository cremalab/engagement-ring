IdeaEditView = require 'views/ideas/idea_edit_view'
User  = require 'models/user'
Idea  = require '/models/idea'
IdeaThread = require 'models/idea_thread'
NotifierStubs = require 'test/lib/notifier_stubs'

describe 'IdeaEditView', ->
  beforeEach ->
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    Chaplin.mediator.apiURL = (path) ->
      "http://nowhere.local/#{path}"
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')

    @thread = new IdeaThread(title: 'Lunch', status: 'open')

    @thread.get('ideas').add({})
    @idea = @thread.get('ideas').last()
    @view = new IdeaEditView model: @idea

  it 'should display formatted date when valid', ->
    @view.natural_input.$el.val('Tomorrow at 3 pm')
    @view.natural_input.translateDate()
    tomorrow_at_3 = moment().add('days',1)
    tomorrow_at_3.set('hour', 15)
    tomorrow_at_3 = tomorrow_at_3.format("dddd MMM D, ha")
    expect(@view.$el.find('.when').text()).to.equal tomorrow_at_3

    @view.natural_input.$el.val('')
    @view.natural_input.translateDate()
    expect(@view.$el.find('.when').text()).to.equal ''