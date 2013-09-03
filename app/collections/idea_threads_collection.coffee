Collection = require 'models/base/collection'
IdeaThread = require 'models/idea_thread'

module.exports = class IdeaThreads extends Collection
  model: IdeaThread
  url: 'http://localhost:3000/idea_threads'
  comparator: (a,b) ->
    a_time = a.get('updated_at')
    b_time = b.get('updated_at')
    if moment(a_time).isBefore(b_time)
      return 1
    else
      return -1
