View = require 'views/base/view'

module.exports = class ActivityView extends View
  autoRender: true
  autoAttach: true
  template: require './templates/show'
  className: 'avatar tooltip'

  render: ->
    super
    @addActionClasses()
    @$el.attr('data-tooltip', @model.get('message'))

  addActionClasses: ->
    key    = @model.get('key')
    split  = key.split('.')
    item   = split[0]
    action = split[1]

    @$el.addClass("#{item} #{action}")