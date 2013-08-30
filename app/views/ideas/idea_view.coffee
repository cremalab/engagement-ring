View = require 'views/base/view'

module.exports = class IdeaView extends View
  template: require './templates/show'
  className: 'idea'