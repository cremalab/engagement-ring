Model = require 'models/base/model'

module.exports = class Activity extends Model
  initialize: ->
    super
    @set 'message', @constructMessage()

  constructMessage: ->
    if @get('owner')
      user_name = @get('owner').name
    else
      user_name = ''

    message = switch @get('trackable_type')
      when "Vote"
        if @get('key') is 'vote.create'
          "voted"
        else
          "revoked their vote"
      when "Comment"
        "left a comment"
      when "Idea"
        "created an idea"

    user_name + " " + message