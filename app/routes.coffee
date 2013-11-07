module.exports = (match) ->
  match '', 'idea_threads#index', name: 'dashboard'

  match 'profiles', 'profiles#index'
  match 'profiles/new', 'profiles#edit'
  match 'profiles/:id/edit', 'profiles#edit'
  match 'profiles/:id/', 'profiles#show'

  match 'me/edit', 'users#edit'
  # match 'users/:id/edit', 'users#edit'

  match 'register', 'users#new'
  match 'login', 'logins#new', name: 'login'
  match 'logout', 'sessions#logout', name: 'logout'

  # match 'ideas', 'ideas#index'
  match 'ideas', 'idea_threads#index', name: 'ideas'
  match 'ideas/archives', 'idea_threads#archive', name: 'ideas_archives'
  match 'ideas/:id', 'idea_threads#show', name: 'idea'

  match 'groups', 'groups#index'