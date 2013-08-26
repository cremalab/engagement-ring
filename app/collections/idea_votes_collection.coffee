Collection = require 'models/base/collection'
IdeaVote = require 'models/idea_vote'

module.exports = class IdeaVotes extends Collection
  model: IdeaVote
