Rails.application.routes.draw do
  post "questions/:question_id/upvote" => "votes#upvote"
  post "answers/:answer_id/upvote" => "votes#upvote"
  post "comments/:comment_id/upvote" => "votes#upvote"
  post "questions/:question_id/downvote" => "votes#downvote"
  post "answers/:answer_id/downvote" => "votes#downvote"
  post "comments/:comment_id/downvote" => "votes#downvote"
  post '/validate_token', to: 'tokens#validate'

  resources :questions, except: [:new, :edit] do
    get "recent_answers"
    get "popular_answers"

    resources :comments, except: [:new, :edit]
    resources :answers, except: [:new, :edit]
  end

  get "top_questions" => "questions#top_questions"

  resources :answers, except: [:index, :show, :create, :destroy, :update, :new, :edit] do
    resources :comments, except: [:new, :edit]
  end

  resources :comments, only: [:update, :delete]

  post "users/logout" => "user#logout"
  get "users" => "users#index"
  get "users/:id" => "users#show"
  get "users/:id/questions" => "users#questions"
  get "users/:id/tags" => "users#tags"
  get 'users/renew_token' => 'users#renew_token'
  get "tags" => "tags#index"
  get "tags/popular" => "tags#popular"
  get "tags/recent" => "tags#recent"
  get "tags/trending" => "tags#trending"

  get 'login', to: "users#login"
  get 'login/:provider', to: "users#login"

  get 'auth/:provider/callback', to: 'users#authenticate', as: :authenticate
  match "*path", to: 'application#resource_not_found', via: :all
end
