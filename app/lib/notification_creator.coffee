IdeaThread = require 'models/idea_thread'

module.exports = class NotificationCreator


  constructor: (model_name, payload) ->
    @current_user    = Chaplin.mediator.user
    switch model_name
      when "IdeaThread"
        @thread_id = payload.id
        @createIdeaThreadNotification(payload)
      when "Idea"
        @thread_id = payload.thread_id
        @createIdeaNotification(payload)
      when "Vote"
        @thread_id = payload.thread_id
        @createVoteNotification(payload)

  createIdeaThreadNotification: (payload) ->
    thread = new IdeaThread(payload)
    unless payload.deleted
      unless payload.user_id is @current_user.get('id') # no need to notify creator
        if thread.userCanVote(@current_user.get('id'))
          title   = "New Idea Thread"
          content = payload.title

          @attributes =
            title: title
            content: content

  createIdeaNotification: (payload) ->
    if @isRelevantNotification(payload)
      user_name = "#{payload.user.profile.first_name} #{payload.user.profile.last_name}"
      title = "New Idea from: #{user_name}"
      content = payload.title

      @attributes =
        title: title
        content: content

  createVoteNotification: (payload) ->
    if @isRelevantNotification(payload)
      @attributes =
        title: "#{payload.user_name} voted on #{payload.idea_title}"
        content: "on the thread: #{payload.thread_title}"

  isRelevantNotification: (payload) ->
    if payload.deleted or payload.user_id is @current_user.get('id')
      return false
    else
      found = false
      Chaplin.mediator.publish 'find_thread', @thread_id, (thread) =>
        if thread
          found = thread
      return found