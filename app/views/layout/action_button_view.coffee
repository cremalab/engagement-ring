View = require 'views/base/view'

module.exports = class ActionButton extends View
  autoAttach: true
  tagName: 'button'
  events:
    'click': "handleClick"

  initialize: (options) ->
    super
    @action_type = options.action_type
    @className = "new"
      
    @render()
    # @template = ->
    #   switch @action_type
    #     when "new_thread"
    #       "New Thread"


  handleClick: ->
