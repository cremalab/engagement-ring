Collection = require 'models/base/collection'
Vote = require 'models/vote'

module.exports = class Votes extends Collection
  model: Vote
  url: 'http://localhost:3000/votes'
