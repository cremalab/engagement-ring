module.exports = (match) ->
  match '', 'idea_threads#index'

  match 'profiles', 'profiles#index'
  match 'profiles/new', 'profiles#edit'
  match 'profiles/:id/edit', 'profiles#edit'
  match 'profiles/:id/', 'profiles#show'

  match 'me/edit', 'users#edit'
  # match 'users/:id/edit', 'users#edit'

  match 'register', 'users#new'
  match 'login', 'logins#new'
  match 'logout', 'sessions#logout'

  # match 'ideas', 'ideas#index'
  match 'ideas', 'idea_threads#index'
  match 'ideas/new', 'ideas#edit'
  match 'ideas/:id/edit', 'ideas#edit'