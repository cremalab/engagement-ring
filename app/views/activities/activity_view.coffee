View = require 'views/base/view'

module.exports = class ActivityView extends View
  autoRender: true
  autoAttach: true

  initialize: (options) ->
    super
    if options.full_view
      # Line-item based template
      @full_view = true
      @template = require './templates/full_show'
    else
      # Avatar-based template
      @template = require './templates/show'

  render: ->
    super
    @addActionClasses()
    @$el.attr('data-tooltip', @model.get('message'))

  addActionClasses: ->
    key    = @model.get('key')
    split  = key.split('.')
    item   = split[0]
    action = split[1]

    @$el.addClass("item-#{item} action-#{action}")
    unless @full_view
      @$el.addClass 'avatar tooltip'