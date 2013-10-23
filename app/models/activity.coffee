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

        'said "' + @truncatedContent() + '"'
      when "Idea"
        "created an idea"

    user_name + " " + message

  truncatedContent: ->
    content = @get('parameters').content
    limit = 30
    length  = content.length
    if length > limit
      return content.substring(0,limit) + "..."
    else
      return content
