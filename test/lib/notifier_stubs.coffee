module.exports =

  idea: (idea_id, thread_id) ->
    stub =
      idea_thread_id: thread_id
      id: 1
      title: "BBQ at Aurthur Bryant's"
      description: "Because I want to feel terrible for the rest of the day"
      user_id: 1
    return stub

  deleted_idea: (idea_id, thread_id) ->
    stub =
      deleted: true
      idea_thread_id: thread_id
      id: 1
    return stub

  vote: (idea_id, user_id) ->
    stub =
      id: 1
      idea_id: idea_id
      user_id: user_id