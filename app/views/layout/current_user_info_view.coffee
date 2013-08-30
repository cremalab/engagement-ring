View = require 'views/base/view'

module.exports = class CurrentUserInfoView extends View
  autoRender: true
  className: 'user-info'
  tagName: 'section'
  template: require './templates/current_user_info'
  listen:
    'change model': 'updateView'

  updateView: (model) ->
    attributes = _.keys model.changed
    _.each attributes, (attr) =>
      $el = @$el.find("[data-bind='#{attr}']")
      if $el.length
        if @model.get(attr) is undefined
          $el.text ''
        else
          $el.text @model.get(attr)

