Rails.application.routes.draw do
  get '/new', to: "games#new"

  post '/score', to: "games#score"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

# Prefix Verb URI Pattern      Controller#Action
#    new GET  /new(.:format)   games#new
#  score POST /score(.:format) games#score
