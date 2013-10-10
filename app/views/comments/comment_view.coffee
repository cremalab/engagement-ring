View = require 'views/base/view'

module.exports = class CommentView extends View
  template: require './templates/show'
  autoRender: true
  autoAttach: true