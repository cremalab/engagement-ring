IdeaThread = require 'models/idea_thread'

module.exports = class NotificationCreator


  constructor: (model_name, payload) ->
    @current_user    = Chaplin.mediator.user
    switch model_name
      when "IdeaThread"
        @createIdeaThreadNotification(payload)
      when "Idea"
        @createIdeaNotification(payload)
      when "Vote"
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
    unless payload.deleted or payload.user_id is @current_user.get('id')
      user_name = "#{payload.user.profile.first_name} #{payload.user.profile.last_name}"
      title = "New Idea from: #{user_name}"
      content = payload.title

      @attributes =
        title: title
        content: content

  createVoteNotification: (payload) ->
    unless payload.deleted or payload.user_id is @current_user.get('id')
      @attributes =
        title: "#{payload.user_name} voted on #{payload.idea_title}"
        content: "on the thread: #{payload.thread_title}"