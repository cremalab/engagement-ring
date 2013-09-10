View = require 'views/base/view'

module.exports = class VotingRightView extends View
  template: require './templates/show'
  autoRender: true
  autoAttach: true
