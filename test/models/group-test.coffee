Group = require 'models/group'
User  = require 'models/group'


describe 'Group', ->
  beforeEach ->
    Chaplin.mediator.user = new User
      email: 'test@cremalab.com'
      id: 1
    Chaplin.mediator.apiURL = (path) ->
      "http://nowhere.local/#{path}"
    @current_user = Chaplin.mediator.user
    @user_id = @current_user.get('id')


  it 'should generate array of voting rights', ->
    memberships = [
      user_id: 2
      group_id: 1
      autocomplete_search: 'Matt Owens'
    ,
      user_id: 3
      group_id: 1
      autocomplete_search: 'Rob LaFeve'
    ,
      user_id: 4
      group_id: 1
      autocomplete_search: 'George Brooks'
    ]

    group = new Group memberships: memberships
    expect(group.prepareVotingRights().length).to.equal 3

  it 'should not include current_user in voting rights', ->
    memberships = [
      user_id: @current_user.get('id')
      group_id: 1
      autocomplete_search: 'Matt Owens'
    ,
      user_id: 2
      group_id: 1
      autocomplete_search: 'Rob LaFeve'
    ,
      user_id: 3
      group_id: 1
      autocomplete_search: 'George Brooks'
    ]

    group  = new Group memberships: memberships
    rights = group.prepareVotingRights()
    expect(rights.length).to.equal 2

    user_right = _.find rights, (right) =>
      right.user_id is @current_user.get('id')
    expect(user_right).to.be.an('undefined')