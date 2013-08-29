Collection = require 'models/base/collection'
Idea = require 'models/idea'

module.exports = class Ideas extends Collection
  model: Idea
  url: 'http://localhost:3000/ideas'
