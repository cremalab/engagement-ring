Collection = require 'models/base/collection'
IdeaThread = require 'models/idea_thread'

module.exports = class IdeaThreads extends Collection
  model: IdeaThread
  url: 'http://localhost:3000/idea_threads'
