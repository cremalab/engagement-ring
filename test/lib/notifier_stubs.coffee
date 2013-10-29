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

  vote: (idea_id, user_id, thread_id) ->
    stub =
      id: 1
      idea_id: idea_id
      user_id: user_id
      user_name: "Ross Brown"
      thread_id: thread_id
      thread_title: "Lunch"
      idea_title: "Grinders"

  comment: (idea_id, user_id) ->
    stub =
      idea_id: idea_id
      user_id: user_id
      user_name: "User Name!"
      created_at: moment()

  idea_thread: (thread_id, user_id) ->
    id: thread_id
    title: "Snack"
    created_at: "2013-10-08T16:25:10.937Z"
    updated_at: "2013-10-08T16:25:10.937Z"
    user_id: user_id
    status: "open"
    original_idea_id: 926
    ideas: []
    model_name: "IdeaThread"
    voting_rights: [
      idea_thread_id: thread_id
      user_id: user_id
      created_at: "2013-10-08T16:25:10.942Z"
      id: 307
      autocomplete_value: user_id
      autocomplete_search: "Rob LaFeve"
    ,
      idea_thread_id: thread_id
      user_id: 3
      created_at: "2013-10-08T16:25:10.943Z"
      id: 308
      autocomplete_value: 3
      autocomplete_search: "Ross Brown"
    ]
    user_name: "Rob LaFeve"