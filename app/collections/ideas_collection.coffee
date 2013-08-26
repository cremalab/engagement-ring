Collection = require 'models/base/collection'
Idea = require 'models/idea'

module.exports = class Ideas extends Collection
  model: Idea
