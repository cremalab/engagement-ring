View = require 'views/base/view'

module.exports = class IdeaVoteView extends View
  template: require './templates/show'
  autoRender: true
  autoAttach: true
