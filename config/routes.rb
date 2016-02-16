Rails.application.routes.draw do
  scope '/:resource_name/:id', constraints: { resource_name: /(questions|answers|comments)/ } do
    post '/upvote', to: 'votes#upvote'
    post '/downvote', to: 'votes#downvote'
  end

  scope '/:resource_name/:resource_id', constraints: { resource_name: /(questions|answers)/} do
    resources :comments, except: [:new, :edit]
  end

  post '/validate_token', to: 'tokens#validate'

  resources :questions, except: [:new, :edit] do
    get "recent_answers"
    get "popular_answers"

    resources :answers, except: [:new, :edit]
  end

  get "top_questions" => "questions#top_questions"

  post "users/logout" => "user#logout"
  get 'users/renew_token' => 'users#renew_token'
  get "users" => "users#index"
  get "users/:id" => "users#show"
  get "users/:id/questions" => "users#questions"
  get "users/:id/tags" => "users#tags"
  get "tags" => "tags#index"
  get "tags/popular" => "tags#popular"
  get "tags/recent" => "tags#recent"
  get "tags/trending" => "tags#trending"

  get 'login', to: "users#login"
  get 'login/:provider', to: "users#login"

  get 'auth/:provider/callback', to: 'users#authenticate', as: :authenticate
  match "*path", to: 'application#resource_not_found', via: :all
end
