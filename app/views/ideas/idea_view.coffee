View = require 'views/base/view'
VotesView = require 'views/votes/votes_collection_view'

module.exports = class IdeaView extends View
  template: require './templates/show'
  className: 'idea'
  regions:
    votes: '.votes'
  events:
    'click .edit': 'edit'


  render: ->
    super
    # console.log @model
    @votes = @model.get('votes')
    votes_view = new VotesView
      collection: @votes
      region: 'votes'
      el: @$el.find('.votes')
    @subview 'votes', votes_view

  edit: (e) ->
    # e.preventDefaut()
    # console.log @model
    @publishEvent 'edit_idea', @model

