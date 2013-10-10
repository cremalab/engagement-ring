Model = require 'models/base/model'

module.exports = class Comment extends Model
  defaults:
    content: ""
    created_at: moment()

  initialize: ->
    super
    if @isNew()
      @set 'user_name', Chaplin.mediator.user.display_name()

  save: ->
    @unset 'user_name'
    super