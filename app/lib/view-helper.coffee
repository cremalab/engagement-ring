# Application-specific view helpers

jade.helpers =
  hasPermission: (user_id) ->
    user_id == Chaplin.mediator.user.get('id')
  isArchivable: (status) ->
    status != 'archived'
  displayName: (user) ->
    if user
      if user.profile
        if user.profile.first_name
          name = "#{user.profile.first_name}#{if user.profile.last_name then ' ' + user.profile.last_name else ''}"
        else
          name = user.email
      else
        name = user.email
    else
      name = ''
    name
  gravatar: (email) ->
    email = $.trim(email).toLowerCase()
    hash = md5(email)
    url = "http://www.gravatar.com/avatar/#{hash}"
    return url
  timely: (string) ->
    unless string is ''
      return timely = moment(string).calendar()
